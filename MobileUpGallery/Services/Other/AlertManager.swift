//
//  AlertManager.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 19.08.2024.
//

import Foundation
import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    private func showAlert(in viewController: UIViewController, title: String, message: String, buttonTitle: String = "OK", buttonAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            buttonAction?()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    func showAutoDismissAlert(in viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showNoInternetConnectionAlert(in viewController: UIViewController) {
        showAlert(
            in: viewController,
            title: "Нет соединения",
            message: "Требуется подключение к интернету для загрузки данных"
        )
    }
    
    func showDataLoadErrorAlert(in viewController: UIViewController) {
        showAlert(
            in: viewController,
            title: "Ошибка",
            message: "Не удалось загрузить данные. Попробуйте снова позже."
        )
    }
    
    func showCustomAlert(in viewController: UIViewController, title: String, message: String, buttonTitle: String, buttonAction: (() -> Void)? = nil) {
        showAlert(
            in: viewController,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            buttonAction: buttonAction
        )
    }
}
