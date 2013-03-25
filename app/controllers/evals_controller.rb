class EvalsController < ApplicationController 
  # GET /evals
  # GET /evals.json
  def index
    @evals = Eval.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @evals }
    end
  end

  # GET /evals/1
  # GET /evals/1.json
  def show
    @eval = Eval.find(params[:id])
    Evaluator::Application::THREAD_POOL.assign(@eval.code) do
      begin
        result = eval(@eval.code)
      rescue Exception => e
        result = "OH NO: #{e}"
      end
      @result = "Current Thread:#{Thread.current[:id]}, Result: #{result}"
    end
    at_exit {Evaluator::Application::THREAD_POOL.shutdown}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eval }
    end
  end

  # GET /evals/new
  # GET /evals/new.json
  def new
    @eval = Eval.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eval }
    end
  end

  # GET /evals/1/edit
  def edit
    @eval = Eval.find(params[:id])
  end

  # POST /evals
  # POST /evals.json
  def create
    @eval = Eval.new(params[:eval])

    respond_to do |format|
      if @eval.save
        format.html { redirect_to @eval, notice: 'Eval was successfully created.' }
        format.json { render json: @eval, status: :created, location: @eval }
      else
        format.html { render action: "new" }
        format.json { render json: @eval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /evals/1
  # PUT /evals/1.json
  def update
    @eval = Eval.find(params[:id])

    respond_to do |format|
      if @eval.update_attributes(params[:eval])
        format.html { redirect_to @eval, notice: 'Eval was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evals/1
  # DELETE /evals/1.json
  def destroy
    @eval = Eval.find(params[:id])
    @eval.destroy

    respond_to do |format|
      format.html { redirect_to evals_url }
      format.json { head :no_content }
    end
  end
end
