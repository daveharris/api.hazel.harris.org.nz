class ImportController < ApplicationController

  def create
    file = params[:file]
    model = file.original_filename
                .split('.').first
                .gsub(' Tracker', '')
                .singularize

    created_models = model.constantize.send(:from_csv, file.tempfile.path)

    render json: { model.pluralize.downcase => created_models }
  end

end
