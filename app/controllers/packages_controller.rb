class PackagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_idea, :only => [:choose_upgrade_method, :upgrade_package]

  def check_promo_code
    @promo = Promo.get_with_code(params[:code])

    respond_to do |format|
      if @promo.nil? || !@promo.valid_promo?
        format.js { render(:invalid_promo) }
      else 
        format.js { render(:valid_promo)  }
      end
    end
  end

  def choose_upgrade_method
    @new_package = params[:package].to_i || Idea::SILVER
    if @new_package <= @idea.package.package
      redirect_to edit_idea_path(@idea, :notice => "You cannot downgrade a package.")
    end
  end

  def upgrade_package
    @new_package = params[:promo][:package].to_i || Idea::SILVER

    respond_to do |format|
      if @idea && @new_package && params[:terms_conditions]
        price = @idea.package.regular_price(@new_package)
        unless params[:promo_code].blank?
          @idea.package.use_promo!(params[:promo_code])  
          price = @idea.package.upgrade_price(@new_package)
        end

        if price > 0
          response = EXPRESS_GATEWAY.setup_purchase(price,
            :ip                => request.remote_ip,
            :return_url        => new_order_url(:code => @idea.package.code),
            :cancel_return_url => root_url, 
            :description => "Package upgrade - #{Package::PACKAGES[@new_package].upcase} ($#{price} #{ActiveMerchant::Billing::PaypalExpressGateway.default_currency})"
          )
          @idea.package.reserve!(@new_package)

          format.html { redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token) }
        else
          @idea.package.reserve!(@new_package)
          @idea.package.paid!
          section = @idea.response_set.survey.sections.where("stage_id = ?", 2).first.id
          format.html { redirect_to edit_tour_path(:idea_id => @idea.id, :section => section) }
        end
      elsif !params[:terms_conditions]
        format.html { redirect_to edit_idea_path(@idea, :notice => "Package upgrade failed. Please read and check T&C.") }
      else
        format.html { redirect_to edit_idea_path(@idea, :notice => "Package upgrade failed. Please contact administrators to resolve this issue.") }
      end
    end
  end

  private

    def get_idea
      @idea = Idea.find params[:idea_id]
      raise unless @idea.is_owner?(current_user)
    end
end