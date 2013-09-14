class ChargesController < ApplicationController
  def new
  end

  # add endpoint for each sales to differentiate by POST request
  def josh
    render :action => :new

    # Possible description identifier in future
    #@sales = 'josh'
  end

  def create
    # Amount in cents
    # Very basic level of sanitization
    @amount = params[:amount].to_i
    @plan = params[:plan]
    
    # check to see if profile setup first
    if @plan == 'setup'
      customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card => params[:stripeToken],
      )
      charge = Stripe::Charge.create(
        :customer   => customer.id,
        :amount     => @amount,
        #:description => @sales,
        :currency => 'usd'
      )

    else 
      # Normal recurrent billing 
      customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card => params[:stripeToken],

        # modify?
        :plan => @plan
      )

      # Store the customer ID into the PG database
      # Infinite loading error?
    end


    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path, :amount => @amount
    end
    
end
