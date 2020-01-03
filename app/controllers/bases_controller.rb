class BasesController < ApplicationController
  before_action :admin_user
  before_action :set_basis, only: [:show, :edit, :update, :destroy]

  # GET /bases
  # GET /bases.json
  def index
    @bases = Base.all
  end

  # GET /bases/1
  # GET /bases/1.json
  def show
  end

  # GET /bases/new
  def new
    @base = Base.new
  end

  # GET /bases/1/edit
  def edit
  end

  # POST /bases
  # POST /bases.json
  def create
    @base = Base.new(basis_params)
      if @base.save
        flash[:success] = "#{@base.name}を登録しました。"
        redirect_to bases_path
      else
        flash[:danger] = "登録に失敗しました。再度入力してください。"
        render :new
      end
  end

  # PATCH/PUT /bases/1
  # PATCH/PUT /bases/1.json
  def update
      if @base.update(basis_params)
        flash[:success] = "#{@base.name}を登録しました。"
        redirect_to bases_path
      else
        flash[:danger] = "登録に失敗しました。再度入力してください。"
        render :new
      end
  end

  # DELETE /bases/1
  # DELETE /bases/1.json
  def destroy
    @base.destroy
    redirect_to bases_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_basis
      @base = Base.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def basis_params
      params.require(:base).permit(:name, :content)
    end
end
