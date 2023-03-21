//
//  RouterView.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import SwiftUI

public struct RouterView<T:View>: View, Router {
    
    @Environment(\.presentationMode) var presentationMode
    let addNavigationView: Bool
    let content: (AnyRouter) -> T
 
    // Segues
    @State private var segueOption: SegueOption = .push
    @State public var screens: [AnyDestination] = []
    
    // Binding to view stack from previous RouterViews
    @Binding private var screenStack: [AnyDestination]
    @State private var screenStackCount: Int = 0

    // Configuration for resizable sheet on iOS 16+
    // TODO: Move resizable sheet modifiers into a struct "SheetConfiguration"
    @State private var sheetDetents: Set<PresentationDetentTransformable> = [.large]
    @State private var sheetSelection: Binding<PresentationDetentTransformable> = .constant(.large)
    @State private var sheetSelectionEnabled: Bool = false
    @State private var showDragIndicator: Bool = true

    // Alerts
    @State private var alertOption: AlertOption = .alert
    @State private var alert: AnyAlert? = nil
    
    // Modals
    @State private var modalConfiguration: ModalConfiguration = .default
    @State private var modal: AnyDestination? = nil
    
    public init(addNavigationView: Bool = true, screens: (Binding<[AnyDestination]>)? = nil, @ViewBuilder content: @escaping (AnyRouter) -> T) {
        self.addNavigationView = addNavigationView
        self._screenStack = screens ?? .constant([])
        self._screenStackCount = State(wrappedValue: (screens?.wrappedValue.count ?? 0))
        self.content = content
    }
    
    public var body: some View {
        NavigationViewIfNeeded(addNavigationView: addNavigationView, segueOption: segueOption, screens: $screens) {
            content(AnyRouter(object: self))
                .showingScreen(
                    option: segueOption,
                    screens: $screens,
                    screenStack: screenStack,
                    sheetDetents: sheetDetents,
                    sheetSelection: sheetSelection,
                    sheetSelectionEnabled: sheetSelectionEnabled,
                    showDragIndicator: showDragIndicator)
                .onChangeIfiOS15(of: presentationMode.wrappedValue.isPresented, perform: dropLastScreenFromStackForiOS16IfNeeded)
        }
        .showingAlert(option: alertOption, item: $alert)
        .showingModal(configuration: modalConfiguration, item: $modal)
    }
    
    func showScreen(_ option: SegueOption, path: RootPath) {
        self.segueOption = option

        if option != .push {
            // Add new Navigation
            // Sheet and FullScreenCover enter new Environments and require a new Navigation to be added.
            self.sheetDetents = [.large]
            self.sheetSelectionEnabled = false
            self.screens.append(AnyDestination(RouterView<AnyView>(addNavigationView: true, screens: nil, content: { router in
                AnyView(handle(path, router: router))
            })))
        } else {
            // Using existing Navigation
            // Push continues in the existing Environment and uses the existing Navigation
            
            
            // iOS 16 uses NavigationStack and can push additional views onto an existing view stack
            if screenStack.isEmpty {
                // We are in the root Router and should start building on $screens
                self.screens.append(AnyDestination(RouterView<AnyView>(addNavigationView: false, screens: $screens, content: { router in
                    AnyView(handle(path, router: router))
                })))
            } else {
                // We are not in the root Router and should continue off of $screenStack
                self.screenStack.append(AnyDestination(RouterView<AnyView>(addNavigationView: false, screens: $screenStack, content: { router in
                    AnyView(handle(path, router: router))
                })))
            }
        }
    }
    
    func pushScreens(destinations: [RootPath]) {
        // iOS 16 supports NavigationStack, which can push a stack of views and increment an existing view stack
        self.segueOption = .push
        
        // Loop on injected destinations and add them to localStack
        // If screenStack.isEmpty, we are in the root Router and should start building on $screens
        // Else, we are not in the root Router and should continue off of $screenStack

        var localStack: [AnyDestination] = []
        let bindingStack = screenStack.isEmpty ? $screens : $screenStack

        destinations.forEach { destination in
            let view = AnyDestination(RouterView<AnyView>(addNavigationView: false, screens: bindingStack, content: { router in
                AnyView(handle(destination, router: router))
            }))
            localStack.append(view)
        }
        
        if screenStack.isEmpty {
            self.screens.append(contentsOf: localStack)
        } else {
            self.screenStack.append(contentsOf: localStack)
        }
    }
    
    func showResizableSheet(sheetDetents: Set<PresentationDetentTransformable>, selection: Binding<PresentationDetentTransformable>?, showDragIndicator: Bool = true, destination: RootPath) {
        self.segueOption = .sheet
        self.sheetDetents = sheetDetents
        self.showDragIndicator = showDragIndicator

        // If selection == nil, then need to avoid using sheetSelection modifier
        if let selection {
            self.sheetSelection = selection
            self.sheetSelectionEnabled = true
        } else {
            self.sheetSelectionEnabled = false
        }
        
        self.screens.append(AnyDestination(RouterView<AnyView>(addNavigationView: true, screens: nil, content: { router in
            AnyView(handle(destination, router: router))
        })))
    }
    
    public func dismissScreen() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    public func popToRoot() {
        self.screens = []
        self.screenStack = []
    }
    
    private func dropLastScreenFromStackForiOS16IfNeeded(isPresented: Bool) {
        // iOS 16 supports screenStack, however,
        // if user dismisses the screen using .dismissScreen or environment modes, then the screen will dismiss without removing last item from screenStack
        // which then leads to the next push appearing on top of existing (incorrect) stack
        
        // This is called when isPresented changes, and should only removeLast if isPresented = false
        
        if !isPresented && screenStack.count == (screenStackCount + 1) {
            screenStack.removeLast()
        }
    }
    
    func showAlert(_ option: AlertOption, title: String, subtitle: String?, alertButtons: [AlertButtonType]) {
        guard self.alert == nil else {
            dismissAlert()
            return
        }
        
        self.alertOption = option
        self.alert = AnyAlert(title: title, subtitle: subtitle, buttons: buildAlertButtons(alertButtons))
    }
    
    public func dismissAlert() {
        self.alert = nil
    }
    
    func showModal(
        transition: AnyTransition,
        animation: Animation,
        alignment: Alignment,
        backgroundColor: Color?,
        backgroundEffect: BackgroundEffect?,
        useDeviceBounds: Bool,
        modalType: ModalType) {
            guard self.modal == nil else {
                dismissModal()
                return
            }
            
            self.modalConfiguration = ModalConfiguration(transition: transition, animation: animation, alignment: alignment, backgroundColor: backgroundColor, backgroundEffect: backgroundEffect, useDeviceBounds: useDeviceBounds)
            self.modal = AnyDestination(buildModalView(modalType))
        }
    
    public func dismissModal() {
        self.modal = nil
    }
    
    @ViewBuilder private func handle(_ destination: RootPath, router: Router) -> some View {
        switch destination {
        case .auth:
            singInScreen(router: router)
                .toolbar(.hidden, for: .navigationBar)
        case .menu:
            Text("menu")
        case .home:
            CharactersListScreen()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    @ViewBuilder private func buildAlertButtons(_ alertButtonTypes: [AlertButtonType]) -> some View {
        ForEach(alertButtonTypes) { alertButtonType in
            switch alertButtonType {
            case .regular(let title, let action):
                Button(role: .none,
                       action: {
                    action?()
                },
                       label: {
                    Text(title)
                })
            case .cancel(let title, let action):
                Button(role: .none,
                       action:  {
                    action?()
                },
                       label: {
                    Text(title)
                })
            case .destructive(let title, let action):
                Button(role: .none,
                       action:  {
                    action?()
                },
                       label: {
                    Text(title)
                })
            }
        }
    }
    
    @ViewBuilder private func buildModalView(_ modalType: ModalType) -> some View {
        switch modalType {
        case .example:
            Text("Modal")
        }
    }

    func singInScreen(router: Router) -> some View {
        SignInBuilder(dependency: DependencyContainer()).build(router: router)
    }
}

//MARK: - Private View Extension

private extension View {
    
    @ViewBuilder func showingScreen(
        option: SegueOption,
        screens: Binding<[AnyDestination]>,
        screenStack: [AnyDestination],
        sheetDetents: Set<PresentationDetentTransformable>,
        sheetSelection: Binding<PresentationDetentTransformable>,
        sheetSelectionEnabled: Bool,
        showDragIndicator: Bool) -> some View {
            self
                .modifier(NavigationLinkViewModifier(
                    option: option,
                    screens: screens,
                    shouldAddNavigationDestination: screenStack.isEmpty
                ))
                .modifier(SheetViewModifier(
                    option: option,
                    screens: screens,
                    sheetDetents: sheetDetents,
                    sheetSelection: sheetSelection,
                    sheetSelectionEnabled: sheetSelectionEnabled,
                    showDragIndicator: showDragIndicator
                ))
                .modifier(FullScreenCoverViewModifier(
                    option: option,
                    screens: screens
                ))
        }
    
    @ViewBuilder func showingAlert(option: AlertOption, item: Binding<AnyAlert?>) -> some View {
        self
            .modifier(ConfirmationDialogViewModifier(option: option, item: item))
            .modifier(AlertViewModifier(option: option, item: item))
    }
    
    func showingModal(configuration: ModalConfiguration, item: Binding<AnyDestination?>) -> some View {
        modifier(ModalViewModifier(configuration: configuration, item: item))
    }
    
    @ViewBuilder func onChangeIfiOS15<E:Equatable>(of value: E, perform: @escaping (E) -> Void) -> some View {
        self
            .onChange(of: value, perform: perform)
    }
}
