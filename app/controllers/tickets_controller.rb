class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.all
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    if @ticket.citizen != current_citizen
      redirect_to tickets_path, notice: 'Not allowed'
    end
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.citizen = current_citizen
    @ticket.winning_id = generate_winning_id @ticket
    begin
      respond_to do |format|
        if @ticket.save
          format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
          format.json { render :show, status: :created, location: @ticket }
        else
          format.html { render :new }
          format.json { render json: @ticket.errors.full_messages, status: :unprocessable_entity }
        end
      end
    rescue ActiveRecord::RecordNotUnique
      redirect_to new_ticket_path, alert: 'Bonul a fost deja înregistrat'
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit!
    end

  private

    def generate_winning_id ticket
      combination = ticket.company_idno + ticket.nr_bon_fiscal + ticket.data_el
      winning_id = Digest::MD5.hexdigest combination
      winning_id
    end


  end
