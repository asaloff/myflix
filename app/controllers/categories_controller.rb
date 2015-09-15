class CategoriesController < AuthenticationController
  def show
    @category = Category.find(params[:id])
  end
end