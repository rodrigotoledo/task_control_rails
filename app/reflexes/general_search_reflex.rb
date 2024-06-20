# frozen_string_literal: true

class GeneralSearchReflex < ApplicationReflex
  def search
    current_controller = params[:current_controller]
    model_class = current_controller.singularize.camelize.constantize
    model_class = model_class.where.not(title: nil).includes(:feature_image_attachment).order(created_at: :desc)
    unless general_search_params[:query].nil?
      model_class = model_class.where("title ILIKE ?", "%#{general_search_params[:query]}%")
    end

    morph "##{current_controller}",
          render(controller: current_controller, partial: "#{current_controller}/#{current_controller.singularize}",
                 collection: model_class.all)
  end

  def general_search_params
    params.require(:general_search).permit(:query)
  end
end
