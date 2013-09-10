class ChargesController < ApplicationController
  def new
  end

  # add endpoint for each sales to differentiate by POST request
  def josh
    render :action => :new
  end

  def create
    # Amount in cents
    # Very basic level of sanitization
    @amount = params[:amount].to_i
    
    if @amount == 500 || @amount == 2000 || @amount == 5000
      customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer   => customer.id,
        :amount     => @amount,
        :description => 'Payment Customer',
        :currency => 'usd'
      )
    end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    end
    
end
