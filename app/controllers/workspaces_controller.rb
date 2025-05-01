class WorkspacesController < ApplicationController
  def new
    @workspace = Workspace.new
  end
  def create
    name = params[:name]
    description = params[:description]
    begin
      Monday::WorkspacesService.new.create_workspace(name, description)
      redirect_to workspaces_path, notice: "Workspace created successfully"
    rescue => e
      flash.now[:alert] = "Error creating workspace: #{e.message}"
      render :new
    end
  end
  def index
    @workspaces = Monday::WorkspacesService.new.get_workspaces

    # for integration tests - adjsut response to match the expected format
    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @workspaces }
    end
  end
  def edit
    @workspace = Monday::WorkspacesService.new.get_workspace(params[:id])
  end
  def update
    workspace_id = params[:id]
    new_name = params[:name]
    begin
      Monday::WorkspacesService.new.rename_workspace(workspace_id, new_name)
      redirect_to workspaces_path, notice: "Workspace renamed to #{new_name}"
    rescue => e
      flash.now[:alert] = "Error renaming workspace: #{e.message}"
      render :edit
    end
  end
  def destroy
    workspace_id = params[:id]
    begin
      Monday::WorkspacesService.new.delete_workspace(workspace_id)
      redirect_to workspaces_path, notice: "Workspace deleted successfully"
    rescue => e
      flash.now[:alert] = "Error deleting workspace: #{e.message}"
      render :index
    end
  end
  def show
    @workspace = Monday::WorkspacesService.new.get_workspace(params[:id])

    # for integration tests - adjsut response to match the expected format
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: @workspace }
    end
  end
  private
  def workspace_params
    params.require(:workspace).permit(:name, :description)
  end
end
