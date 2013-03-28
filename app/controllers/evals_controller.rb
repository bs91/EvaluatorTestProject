class EvalsController < ApplicationController
  require 'thread'
  respond_to :html, :js, :json

 
  # GET /evals
  # GET /evals.json
  def index
    @evals = Eval.all
    respond_with(@evals) 
  end

  # GET /evals/1
  # GET /evals/1.json
  def show
    @eval = Eval.find(params[:id])
    Thread.new {
      begin
        result = eval(@eval.code)
      rescue Exception => e
        result = "OH NO: #{e}"
      ensure
        @result = "Current Thread:#{Thread.current}, Result: #{result}"
      end
    }.join(10)
    respond_with(@eval)
  end

  # GET /evals/new
  # GET /evals/new.json
  def new
    @eval = Eval.new
    respond_with(@eval)
  end

  # GET /evals/1/edit
  def edit
    @eval = Eval.find(params[:id])
    respond_with(@eval)
  end

  # POST /evals
  # POST /evals.json
  def create
    @eval = Eval.new(params[:eval])
    @eval.save and flash[:notice] = "Yay! New Eval Created!"
    respond_with(@eval)
  end

  # PUT /evals/1
  # PUT /evals/1.json
  def update
    @eval = Eval.find(params[:id])
    if @eval.update_attributes(params[:eval])
      flash[:notice] = "Eval was successfully updated."
      respond_with(@eval)
    else
      respond_with(@eval.errors)
    end
  end

  # DELETE /evals/1
  # DELETE /evals/1.json
  def destroy
    @eval = Eval.find(params[:id])
    @eval.destroy
    redirect_to(evals_url)
  end
end
