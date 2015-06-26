class CategoriesController < Frontend::CommonController
  layout 'searcher_and_side_bar'
  before_action :set_category, except: [:index]

  def index
    @categories = Category.in_frontend
  end

  def show
  end

  def tags
    @variables ||= {}
    @variables['products'] = Product
                                 .joins(:products_tags)
                                 .where(products_tags: {tag_id: params[:tag_ids]})
    render '/searches/index'
  end

  def get_template_variables(template)
    super

    @variables['products'] = []
    @variables['products'] = Product.in_frontend(@category) unless @category.nil?

    array_categories = Utils.get_parents_array(@category)
    array_categories.delete_at(0) if array_categories.any?  # delete root.
    array_categories << @category unless @category.nil?     # append current.

    array_categories.each do |category|
      add_breadcrumb(Breadcrumb.new(url: show_slug_categories_path(category.slug), name: category.name))
    end
  end

  protected

  def set_breadcrumbs
  end

  def set_category
    @category = nil

    if !params[:slug].blank? || !params[:id].blank?
      attributes = {enabled: true}
      attributes[:slug] = params[:slug] unless params[:slug].blank?
      attributes[:id] = params[:id] unless params[:id].blank?

      @category = Category.find_by(attributes)

      unless @category.nil?
        @variables ||= {}
        @variables['tags_group'] = TagsGroup.general_groups(@category.id)
      end
    end
  end
end
