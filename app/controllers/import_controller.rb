class ImportController < ApplicationController

  def create
    progress = {}

    params.fetch(:attachments, {}).each do |attachment|
      model = attachment[:file_name]
                .split('.').first
                .gsub(' Tracker', '')
                .singularize

      if model_object = model.safe_constantize
        Rails.logger.debug "Found #{model} attachment. Importing ..."

        decoded = Base64.decode64(attachment[:content]).force_encoding('UTF-8').encode(universal_newline: true)
        status = model_object.public_send(:from_csv, StringIO.new(decoded))

        Rails.logger.info "Imported #{status.ids.size} #{model.pluralize} via #{status.num_inserts} SQL inserts"
        progress[model.pluralize.downcase] = status
      end
    end

    render json: progress
  end

end
