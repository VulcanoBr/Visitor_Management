class VisitorsController < ApplicationController

  before_action :authenticate_user!

  def new
    @visitor = Visitor.new
  end

  def create
    @visitor = Visitor.new(visitor_params)
    if params[:visitor][:photo].present?
      uploaded_file = params[:visitor][:photo]
      cpf = @visitor.cpf
      key = "#{cpf}_#{Time.now.strftime('%Y%m%d%H%M%S')}.jpg"
      @visitor.photo.attach(
        io: uploaded_file.tempfile,
        filename: uploaded_file.original_filename,
        content_type: uploaded_file.content_type,
        key: key
      )
    end

    if @visitor.save
      respond_to do |format|
        format.turbo_stream do

          render turbo_stream: [
            # Atualiza os campos na view do Visit com os dados do visitante
            turbo_stream.replace(
                "visitor_id_field",
                "<input type='hidden' id='visitor_id' name='visit[visitor_id]' value='#{@visitor.id}' data-visitor-search-target='visitorId'>"
              ),
            turbo_stream.update("visitor_cpf", @visitor.cpf),
            turbo_stream.update("visitor_name", @visitor.name),
            turbo_stream.update("visitor_phone", @visitor.phone),
            turbo_stream.update("visitor_company", @visitor.company),

            # Para a foto, precisamos garantir que seja uma URL válida
            turbo_stream.replace("visitor_photo",
              "<img id='visitor_photo' src='#{@visitor.photo.attached? ? url_for(@visitor.photo) : ''}'
              alt='Foto do Visitante' class='img-thumbnail'
              style='width: 150px; height: 150px; object-fit: cover;'
              data-visitor-search-target='visitorPhoto'>"),

            # Torna o bloco de informações do visitante visível
              turbo_stream.update("visitor_info_visibility",
                  "<script>document.getElementById('visitor_info').style.display = 'block';
                            document.getElementById('employee_search_section').style.display = 'block';</script>"),

            # Fecha o modal
              turbo_stream.update("modal_close_action",
                "<script>var modal = bootstrap.Modal.getInstance(document.getElementById('visitorModal'));if(modal) modal.hide();</script>")


          ]
        end
      end
      flash.now[:notice] = 'Visitor cadastrado com sucesso. !!!'
    else

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_visitor_form",
            partial: "visitors/form",
            locals: { visitor: @visitor }
          )
        end
      end
    end
  end


  def search
    visitor = Visitor.find_by(cpf: params[:cpf])

    if visitor
      render json: {
        id: visitor.id,
        cpf: visitor.cpf,
        name: visitor.name,
        phone: visitor.phone,
        company: visitor.company,
        photo_url: visitor.photo.attached? ? url_for(visitor.photo) : nil
      }
    else
      render json: nil, status: :not_found
    end
  end

  private

  def visitor_params
    params.require(:visitor).permit(:name, :cpf, :phone, :company, :photo)
  end
end
