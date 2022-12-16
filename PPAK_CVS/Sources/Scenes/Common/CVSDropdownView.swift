import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

enum CVSDropdownCase {
  case cvs(CVSType)
  case setting
}

final class CVSDropdownView: UIView {

  // MARK: - Properties

  private lazy var allButton = createLogoButton(CVSType.all.image)
  private lazy var elevenButton = createLogoButton(CVSType.sevenEleven.image)
  private lazy var cuButton = createLogoButton(CVSType.cu.image)
  private lazy var emartButton = createLogoButton(CVSType.eMart.image)
  private lazy var gsButton = createLogoButton(CVSType.gs.image)
  private lazy var ministopButton = createLogoButton(CVSType.miniStop.image)
  private lazy var settingButton = createLogoButton(#imageLiteral(resourceName: "ic_gear"))

  private lazy var stackView = UIStackView(
    arrangedSubviews: [allButton, cuButton, gsButton, elevenButton, ministopButton, emartButton, settingButton]
  ).then {
    $0.spacing = 12
    $0.axis = .vertical
  }

  let buttonEventSubject = PublishSubject<CVSDropdownCase>()
  let disposeBag = DisposeBag()

  // MARK: - LifeCycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyles()
    setupLayout()
    setupConstraints()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setupStyles() {
    backgroundColor = .white
    layer.cornerRadius = 16.0
    layer.shadowOpacity = 0.2
    layer.shadowColor = UIColor.black.cgColor
  }

  private func setupLayout() {
    addSubview(stackView)
  }

  private func setupConstraints() {
    stackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(12)
    }
  }

  // MARK: - Bind

  private func bind() {

    // All 버튼 이벤트
    allButton.rx.tap
      .map { CVSDropdownCase.cvs(.all) }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // CU 버튼 이벤트
    cuButton.rx.tap
      .map { CVSDropdownCase.cvs(.cu) }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // GS 버튼 이벤트
    gsButton.rx.tap
      .map { CVSDropdownCase.cvs(.gs) }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // Emart 버튼 이벤트
    emartButton.rx.tap
      .map { CVSDropdownCase.cvs(.eMart) }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // Ministop 버튼 이벤트
    ministopButton.rx.tap
      .map { CVSDropdownCase.cvs(.miniStop) }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // 7Eleven 버튼 이벤트
    elevenButton.rx.tap
      .map { CVSDropdownCase.cvs(.sevenEleven) }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // Setting 버튼 이벤트
    settingButton.rx.tap
      .map { CVSDropdownCase.setting }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)
  }

  // MARK: - Helpers

  private func createLogoButton(_ image: UIImage?) -> UIButton {
    let button = UIButton()
    button.setImage(image, for: .normal)
    button.snp.makeConstraints { make in
      make.width.height.equalTo(40)
    }

    return button
  }
}
