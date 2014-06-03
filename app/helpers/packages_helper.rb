module PackagesHelper
  def choosen_package(package)
	 "#{Package::PACKAGES[package].capitalize} ($#{Package::PRICE[package]})"
  end

  def current_package(idea)
    "#{Package::PACKAGES[idea.package].capitalize} ($#{Package::PRICE[idea.package]})"
  end

  def package_button_css_class(package)
    case package.package
      when Package::FREE
        'btn-free'
      when Package::SILVER
        'btn-silver'
      when Package::GOLD
        'btn-gold'
      when Package::PLATINUM
        'btn-platinum'
      else
        'btn-free'
    end
  end
end
