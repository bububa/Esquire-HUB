# encoding: UTF-8
class ExpensesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :index, :show, :edit, :update, :destroy]
  before_filter :editor_or_editor_manager_authenticate, :only => [:new, :create, :index, :show, :edit, :update, :destroy]
  before_filter :correct_user, :only=>[:index, :new, :create, :show, :edit, :update, :destroy]
  before_filter :not_closed, :only=>[:new, :create, :edit, :update, :destroy]
  
  def index
    @title = "报销类目"
  end
  
  def new
    @expense = Expense.new
    @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
    @exp_types = Array[*Constants::ExpenseTypes.collect {|v,i| [v,Constants::ExpenseTypes.index(v)] }]
    @exp_type = params[:exp_type].to_i
    @title = "新报销项目"
    render "new"
  end
  
  def create
    params[:expense][:user_id] = current_user.id
    @expense = Expense.new(params[:expense])
    if @expense.save
      contact_info = {:name=>@expense.author, :realname=>@expense.realname, :address=>@expense.address, :email=>@expense.email, :idcard=>@expense.idcard, :bankno=>@expense.bankno, :bank=>@expense.bank, :user_id=>current_user.id, :career=>@expense.career}
      @contact = Contact.new(contact_info)
      if @contact.save
        flash[:success] = "新建联系人"
      else
        @contact = Contact.find_by_name_and_career_and_user_id(contact_info[:name], contact_info[:career], contact_info[:user_id])
        contact_info.delete(:name, :career, :user_id)
        @contact.update_attributes(contact_info)
      end
      flash[:success] = "添加报销项目成功!"
      redirect_to expenses_article_path(@article)
    else
      @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
      @exp_types = Array[*Constants::ExpenseTypes.collect {|v,i| [v,Constants::ExpenseTypes.index(v)] }]
      @exp_type = params[:expense][:exp_type].to_i
      @title = "新报销项目"
      render "new"
    end
  end
  
  def edit
    @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
    @exp_types = Array[*Constants::ExpenseTypes.collect {|v,i| [v,Constants::ExpenseTypes.index(v)] }]
    @title = "编辑报销条目"
    render "edit"
  end
  
  def update
    if @expense.update_attributes(params[:expense])
      contact_info = {:name=>@expense.author, :realname=>@expense.realname, :address=>@expense.address, :email=>@expense.email, :idcard=>@expense.idcard, :bankno=>@expense.bankno, :bank=>@expense.bank, :career=>@expense.career}
      @contact = current_user.contacts.build(contact_info)
      if !@contact.save
        @contact = Contact.find_by_name_and_career_and_user_id(contact_info[:name], contact_info[:career], current_user.id)
        contact_info.delete(:name)
        contact_info.delete(:career)
        @contact.update_attributes(contact_info)
        flash[:notice] = "更新联系人 #{@contact.name}"
      else
        flash[:notice] = "新建联系人 #{@contact.name}"
      end
      respond_to do |format|
        format.js {render :json=>@expense}
        format.html {
          flash[:success] = "报销条目已经更新"
          redirect_to expenses_article_path(@article)
        }
      end
      
    else
      respond_to do |format|
        format.js {render :json=>@user.errors}
        format.html {
          @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
          @exp_types = Array[*Constants::ExpenseTypes.collect {|v,i| [v,Constants::ExpenseTypes.index(v)] }]
          @title = "编辑报销条目"
          render "edit"
        }
      end
    end
  end
  
  def destroy
    @expense.destroy
    flash[:success] = "条目已经删除!"
    redirect_to expenses_article_path(@expense.article)
  end
  
  private
  
    def correct_user
      if params.has_key?(:id)
        @expense = Expense.find(params[:id])
        @article = Article.fetch(@expense.article_id)
        redirect_to(root_path) unless ( current_user?(User.fetch(@expense.user_id)) || authorized?([Authority::Admin, Authority::EditorManager]) )
      elsif params.has_key?(:article_id) || params.has_key?(:expense)
        @article = params[:article_id].nil? ? Article.fetch(params[:expense][:article_id]) : Article.fetch(params[:article_id])
        redirect_to(root_path) unless ( current_user?(User.fetch(@article.editor_id)) || authorized?([Authority::Admin, Authority::EditorManager]) )
      end
    end
    
    def not_closed
      if @article.closed
        flash[:warning] = "该软文已经结案"
        redirect_to expenses_article_path(@article)
      end
    end
    
    def expenses_article_path(article)
      "#{root_url}expenses/#{article.id}"
    end

end
