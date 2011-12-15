# encoding: UTF-8
class ArticlesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :index, :show, :edit, :update]
  before_filter :sales_or_editor_manager_authenticate, :only => [:new, :create]
  before_filter :correct_user, :only=>[:show, :edit, :update]
  before_filter :not_closed, :only=>[:edit, :update]
  
  def index
    @per_page = 30
    @title = "策划软文列表"
    if sales_user?
      @conditions = ["sales_id=?", current_user.id]
    elsif editor_manager_user?
      @conditions = ["editor_manager_id=?", current_user.id]
      @editors = []
      @designers = []
      User.fetch_all.each do |user|
        @editors << [user.name, user.id] if editor_user?(user)
        @designers << [user.name, user.id] if designer_user?(user)
      end
    elsif supervisor_user? || admin_user?
      @conditions = nil
    elsif editor_user?
      @conditions = ["editor_id=? AND canceled=?", current_user.id, false]
    elsif designer_user?
      @conditions = ["designer_id=? AND canceled=?", current_user.id, false]
    end
    @articles = Article.paginate(:page => params[:page], :per_page => @per_page, :conditions => @conditions)
  end
  
  def show
    @title = "软文 [#{@article.subject}]"
  end
  
  def new
    @article = Article.new
    @editor_managers = []
    @sales = []
    @forms = Array[*Constants::Forms.collect {|v,i| [v,Constants::Forms.index(v)] }]
    @positions = Array[*Constants::Positions.collect {|v,i| [v,Constants::Positions.index(v)] }]
    User.fetch_all.each do |user|
      @editor_managers << [user.name, user.id] if editor_manager_user?(user)
      @sales << [user.name, user.id] if sales_user?(user)
    end
    @title = "创建软文"
  end
  
  def create
    if sales_user?
      params[:article][:sales_id] = current_user.id
    elsif editor_manager_user?
      params[:article][:editor_manager_id] = current_user.id
    end
    params[:article][:canceled] = false
    params[:article][:closed] = false
    @article = Article.new(params[:article]) 
    if @article.save
      #@message = Message.new({:from_user_id=>current_user.id, :to_user_id=>@article.editor_manager_id, :auto=>true, :unread=>true, :msg=>"#{current_user.name} 新建 #{@article.brand} 软文 \"#{@article.subject}\"."})
      #@message.save
      msg = {:from_user_id=>current_user.id, :to_user_id=>@article.editor_manager_id, :auto=>true, :unread=>true, :msg=>"#{current_user.name} 新建 #{@article.brand} 软文 \"#{@article.subject}\"."}
      MessagesController::new_message(msg)
      flash[:success] = "创建软文成功!"
      redirect_to articles_path
    else
      @editor_managers = []
      @sales = []
      @forms = Array[*Constants::Forms.collect {|v,i| [v,Constants::Forms.index(v)] }]
      @positions = Array[*Constants::Positions.collect {|v,i| [v,Constants::Positions.index(v)] }]
      User.fetch_all.each do |user|
        @editor_managers << [user.name, user.id] if editor_manager_user?(user)
        @sales << [user.name, user.id] if sales_user?(user)
      end
      @title = "创建软文"
      render "new"
    end
  end
  
  def edit
    @forms = Array[*Constants::Forms.collect {|v,i| [v,Constants::Forms.index(v)] }]
    @positions = Array[*Constants::Positions.collect {|v,i| [v,Constants::Positions.index(v)] }]
    @editors = []
    @designers = []
    @sales = []
    User.fetch_all.each do |user|
      @editors << [user.name, user.id] if editor_user?(user)
      @designers << [user.name, user.id] if designer_user?(user)
      @sales << [user.name, user.id] if sales_user?(user)
    end
    @title = "修改"
  end
  
  def update
    if params.has_key?(:got_material)
      now = Time.zone.now
      attrs = {:article=>{:material_at=>now}}
    elsif params.has_key?(:got_draft)
      now = Time.zone.now
      attrs = {:article=>{:draft_at=>now}}
    elsif params.has_key?(:got_final)
      now = Time.zone.now
      attrs = {:article=>{:final_at=>now}}
    elsif params.has_key?(:print_at)
      now = Time.zone.now
      attrs = {:article=>{:print_at=>now}}
    elsif params.has_key?(:print_confirm)
      now = Time.zone.now
      if editor_user? 
        attrs = {:article=>{:editor_sign_at=>now}}
      elsif sales_user? 
        attrs = {:article=>{:sales_sign_at=>now}}
      end
    else
      attrs = params
    end
    @article = Article.find(params[:id])
    if @article.update_attributes(attrs[:article])
      if editor_manager_user? && !attrs[:article][:editor_id].nil? && attrs[:article][:no].nil?
        @message = Message.new({:from_user_id=>current_user.id, :to_user_id=>@article.editor.id, :auto=>true, :unread=>true, :msg=>"#{current_user.name} 分配 #{@article.brand} 软文 #{@article.subject} 给你."})
      end
      respond_to do |format|
        format.js {
          if !now.nil?
            render :json=>{:signed_at=>now.strftime("%Y-%m-%d %X")}
            return
          end
          render :json=>@article
        }
        format.html {
          flash[:success] = "修改软文"
          redirect_to @article
        }
      end
      
    else
      respond_to do |format|
        format.js {render :json=>@article.errors}
        format.html {
          @forms = Array[*Constants::Forms.collect {|v,i| [v,Constants::Forms.index(v)] }]
          @positions = Array[*Constants::Positions.collect {|v,i| [v,Constants::Positions.index(v)] }]
          @editors = []
          @designers = []
          @sales = []
          User.fetch_all.each do |user|
            @editors << [user.name, user.id] if editor_user?(user)
            @designers << [user.name, user.id] if designer_user?(user)
            @sales << [user.name, user.id] if sales_user?(user)
          end
          @title = "修改软文"
          render 'edit'
        }
      end
    end
  end
  
  private
  
    def correct_user
      @article = Article.fetch(params[:id])
      if sales_user? and current_user.id!=@article.sales_id or editor_user? and current_user.id!=@article.editor_id or designer_user? and current_user.id!=@article.designer_id or editor_manager_user? and current_user.id!=@article.editor_manager_id
        deny_access
      end
    end
    
    def not_closed
      if @article.closed && !editor_manager_user?
        flash[:warning] = "该软文已经结案"
        redirect_to @article
      end
    end
end
