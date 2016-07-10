class Api::ItemsController < ApplicationController
  before_action :set_item, only: [:show]

  def upload
    raise ArgumentError, 'invalid params' if params[:name].blank? || params[:image].blank?

    item = Item.new(item_params)
    if item.save
      render json: {
        message: 'Item is uploaded',
      }
    else
      render status: 422
    end
  end

  def show
    item_image = @item.image_with_cache

    send_data(
      item_image,
      type: @item.image.content_type,
      filename: @item.name,
      disposition: 'inline'
    )
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.permit(:name, :image)
    end
end
