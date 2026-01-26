import Foundation
import UIKit

extension MainChatViewController {
    func setupNavigationBar() {
        title = "Vault AI"

        let history = UIBarButtonItem(
            image: UIImage(systemName: "clock.arrow.circlepath"),
            style: .plain,
            target: self,
            action: #selector(handleHistoryTap)
        )

        let more = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(handleMoreTap)
        )

        more.tintColor = .systemBlue
        history.tintColor = .systemBlue

        navigationItem.leftBarButtonItem = history
        navigationItem.rightBarButtonItem = more

        configureNavBarAppearance()
    }

    private func configureNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.25)
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .semibold), .foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34, weight: .bold)]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.isTranslucent = false
    }

    @objc func handleHistoryTap() {
        print("History tapped")
        Haptics.impact()
    }

    @objc func handleMoreTap() {
        print("More tapped")
        Haptics.impact()
    }
}
