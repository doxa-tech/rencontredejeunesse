class Admin::ItemsController < Admin::BaseController
  load_and_authorize

  def index
    @table = ItemTable.new(self, @items)
		@table.respond
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(items_params)
    if @item.save
      redirect_to admin_items_path, success: "Produit créé"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(items_params)
      redirect_to edit_admin_item_path(@item), success: "Produit mis à jour"
    else
      render 'edit'
    end
  end

  def destroy
    @item.destroy
		redirect_to admin_items_path, success: "Produit supprimé"
  end

  private

  def items_params
    params.require(:item).permit(:name, :description, :price, :number, :active, :valid_from, :valid_until, :order_bundle_id)
  end

end
