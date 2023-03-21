//
//  AnyRouter.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

/// Type-erased Router with convenience methods.
public struct AnyRouter: Router {
    private let object: any Router
    
    init(object: any Router) {
        self.object = object
    }
    
    public var screens: [AnyDestination] {
        object.screens
    }
    
    /// Show any screen via Push (NavigationLink), Sheet, or FullScreenCover.
    func showScreen(_ option: SegueOption, path: RootPath) {
        object.showScreen(option, path: path)
    }
    
    /// Dismiss the top-most presented screen in the current Environment. Same as calling presentationMode.wrappedValue.dismiss().
    public func dismissScreen() {
        object.dismissScreen()
    }

    /// Dismiss all NavigationLinks in NavigationStack heirarchy.
    func pushScreens(destinations: [RootPath]) {
        object.pushScreens(destinations: destinations)
    }
    
    func showResizableSheet(sheetDetents: Set<PresentationDetentTransformable>, selection: Binding<PresentationDetentTransformable>?, showDragIndicator: Bool, destination: RootPath) {
        object.showResizableSheet(sheetDetents: sheetDetents, selection: selection, showDragIndicator: showDragIndicator, destination: destination)
    }
        
    /// Dismiss all NavigationLinks in NavigationStack heirarchy.
    ///
    ///  WARNING: Does not dismiss Sheet or FullScreenCover.
    public func popToRoot() {
        object.popToRoot()
    }
    
    /// Show any Alert or ConfirmationDialog.
    ///
    ///  WARNING: Alert modifiers were deprecated between iOS 14 & iOS 15. iOS 15+ will use '@ViewBuilder alert' parameter, while iOS 14 and below will use 'buttonsiOS13' parameter.
    func showAlert(_ option: AlertOption, title: String, subtitle: String?, alertButtons: [AlertButtonType]) {
        object.showAlert(option, title: title, subtitle: subtitle, alertButtons: alertButtons)
    }
    
    /// Convenience method for a simple alert with title text and ok button.
    public func showBasicAlert(text: String, action: (() -> Void)? = nil) {
        showAlert(.alert, title: text, subtitle: nil, alertButtons: [.regular("OK", nil)])
    }
    
    /// Dismiss presented alert. Note: Alerts often dismiss themselves. Calling this anyway is ok.
    public func dismissAlert() {
        object.dismissAlert()
    }
    
    /// Show any Modal over the current Environment.
    func showModal(
        transition: AnyTransition = AnyTransition.opacity.animation(.default),
        animation: Animation = .default,
        alignment: Alignment = .center,
        backgroundColor: Color? = Color.black.opacity(0.001),
        backgroundEffect: BackgroundEffect? = nil,
        useDeviceBounds: Bool = true,
        modalType: ModalType){
        object.showModal(transition: transition, animation: animation, alignment: alignment, backgroundColor: backgroundColor, backgroundEffect: backgroundEffect, useDeviceBounds: useDeviceBounds, modalType: modalType)
    }
    
    /// Convenience method for a simple modal appearing over the current Environment in the center of the screen.
    func showBasicModal(modalType: ModalType) {
        showModal(
            transition: AnyTransition.opacity.animation(.easeInOut),
            animation: .easeInOut,
            alignment: .center,
            backgroundColor: Color.black.opacity(0.4),
            useDeviceBounds: false,
            modalType: modalType)
    }
    
    public func dismissModal() {
        object.dismissModal()
    }
}
