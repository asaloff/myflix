class RelationshipsController < AuthenticationController
  def index
    @relationships = current_user.relationships
  end

  def create
    user = User.find(params[:following_id])
    Relationship.create(user: current_user, following: user)
    redirect_to user
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.user == current_user
    redirect_to people_path
  end
end