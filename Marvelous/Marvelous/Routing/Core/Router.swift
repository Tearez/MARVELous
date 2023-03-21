//
//  Router.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import SwiftUI
import Combine

enum RootPath: Hashable {
    case auth
    case home
    case menu
}

protocol Router {
    var screens: [AnyDestination] { get }
    func showScreen(_ option: SegueOption, path: RootPath)
    func dismissScreen()

    func pushScreens(destinations: [RootPath])
    
    func popToRoot()
    
    func showResizableSheet(sheetDetents: Set<PresentationDetentTransformable>, selection: Binding<PresentationDetentTransformable>?, showDragIndicator: Bool, destination: RootPath)
    
    func showAlert(_ option: AlertOption, title: String, subtitle: String?, alertButtons: [AlertButtonType])
    
    func dismissAlert()
    
    func showModal(transition: AnyTransition, animation: Animation, alignment: Alignment, backgroundColor: Color?, backgroundEffect: BackgroundEffect?, useDeviceBounds: Bool, modalType: ModalType)
    func dismissModal()
}
