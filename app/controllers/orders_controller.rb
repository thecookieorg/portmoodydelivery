require 'twilio-ruby'

class OrdersController < ApplicationController
  include CurrentCart
  before_action :authenticate_user!
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to root_url, notice: "Your cart is empty"
      return
    end

    @order = current_user.orders.build

    $items = []

    @cart.line_items.each do |line_item|
      item_hash = {
          :quantity => line_item.quantity,
          :name => "#{line_item.product.name}",
      }
      $items.push(item_hash)
    end

    $message_body = $items.to_a

    #$items.each do |key, val|
    #  "#{key}: #{val}\n"
    #end


  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.build(order_params)
    @order.add_line_items_from_cart(@cart)

    # STRIPE INTEGRATION
    @amount = @cart.total_price.to_i * 100

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: 'Port Moody Delivery',
      currency: 'cad'
    )


    respond_to do |format|
      if @order.save

        send_text_message
        
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil

        format.html { redirect_to root_url, notice: 'Thank you for your order' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:pay_type, :stripeEmail, :stripeToken, :stripe_card_token, :product_id)
    end

    def send_text_message
      number_to_send_to = '+16043568259'

      twilio_sid = ENV["twilio_sid"]
      twilio_token = ENV["twilio_token"]
      twilio_phone_number = "604-265-5481"

      @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

      @twilio_client.account.sms.messages.create(
          from: "+1 #{twilio_phone_number}",
          to: number_to_send_to,
          body: $message_body[0]
        )
    end
end
