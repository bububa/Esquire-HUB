# encoding: UTF-8
class MagzinesController < ApplicationController
  before_filter :authenticate, :only => [:show]
  before_filter :editor_or_editor_manager_or_supervisor_authenticate, :only => [:show]
  
  def index
    @title = "刊期"
  end
  
  def show
    # 统计信息
    @total = 0
    @finished = 0
    @delay_material = 0
    @delay_draft = 0
    @delay_final = 0
    articles = Article.where(:no=>params[:no])
    articles.each do |article|
      @total += 1
      if !article.print_at.nil? || article.closed
        @finished += 1
      end
      if !article.material_on.nil? && !article.material_at.nil? && article.material_on < Date.new(article.material_at.year, article.material_at.month, article.material_at.day)
        @delay_material += 1
      end
      if !article.draft_on.nil? && !article.draft_at.nil? && article.draft_on < Date.new(article.draft_at.year, article.draft_at.month, article.draft_at.day)
        @delay_draft += 1
      end
      if !article.final_on.nil? && !article.final_at.nil? && article.final_on < Date.new(article.final_at.year, article.final_at.month, article.final_at.day)
        @delay_final += 1
      end
    end
    # 报销单据
    if editor_manager_user? || supervisor_user? || admin_user?
      expenses = Expense.includes(:user, :article).joins(:article).where(:articles => {:no => params[:no]})
    else
      expenses = Expense.includes(:user, :article).joins(:article).where(:articles => {:no => params[:no]}, :user_id=>current_user.id)
    end
    @expenses = {}
    expenses.each do |expense|
      @expenses[expense.user.name] = {} unless @expenses.has_key?(expense.user.name)
      @expenses[expense.user.name][expense.exp_type] = {} unless @expenses[expense.user.name].has_key?(expense.exp_type)
      key = "#{expense.author}#{expense.idcard}"
      @expenses[expense.user.name][expense.exp_type][key] = [] unless @expenses[expense.user.name][expense.exp_type].has_key?(key)
      @expenses[expense.user.name][expense.exp_type][key] << expense
    end
    y,m,d = params[:no].split('-')
    @title = "#{y}年#{m}月刊"
  end

end
