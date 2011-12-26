# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111220155442) do

  create_table "article_stats", :force => true do |t|
    t.date     "no"
    t.integer  "total"
    t.integer  "finished"
    t.integer  "delay_material"
    t.integer  "delay_draft"
    t.integer  "delay_final"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_stats", ["no"], :name => "index_article_stats_on_no", :unique => true

  create_table "articles", :force => true do |t|
    t.date     "no"
    t.string   "brand"
    t.integer  "pages"
    t.string   "subject"
    t.integer  "editor_manager_id"
    t.integer  "sales_id"
    t.integer  "editor_id"
    t.integer  "designer_id"
    t.integer  "form"
    t.integer  "position"
    t.date     "material_on"
    t.datetime "material_at"
    t.date     "draft_on"
    t.datetime "draft_at"
    t.date     "final_on"
    t.datetime "final_at"
    t.datetime "sales_sign_at"
    t.datetime "editor_sign_at"
    t.datetime "print_at"
    t.text     "comment"
    t.boolean  "canceled"
    t.boolean  "closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["brand"], :name => "index_articles_on_brand"
  add_index "articles", ["canceled"], :name => "index_articles_on_canceled"
  add_index "articles", ["designer_id"], :name => "index_articles_on_designer_id"
  add_index "articles", ["editor_manager_id"], :name => "index_articles_on_editor_manager_id"
  add_index "articles", ["no"], :name => "index_articles_on_no"
  add_index "articles", ["sales_id"], :name => "index_articles_on_sales_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "realname"
    t.string   "address"
    t.string   "email"
    t.string   "idcard"
    t.string   "bankno"
    t.string   "bank"
    t.integer  "career"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  add_index "contacts", ["idcard", "career", "user_id"], :name => "index_contacts_on_idcard_and_career_and_user_id", :unique => true
  add_index "contacts", ["name", "career", "user_id"], :name => "index_contacts_on_name_and_career_and_user_id", :unique => true

  create_table "expenses", :force => true do |t|
    t.string   "author"
    t.string   "realname"
    t.string   "address"
    t.string   "email"
    t.string   "idcard"
    t.integer  "article_id"
    t.integer  "text_count"
    t.float    "fee_per_word"
    t.integer  "pages"
    t.float    "fee_per_page"
    t.float    "total_fee"
    t.float    "tax"
    t.float    "paid"
    t.string   "bankno"
    t.string   "bank"
    t.integer  "user_id"
    t.integer  "exp_type"
    t.integer  "career"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expenses", ["article_id"], :name => "index_expenses_on_article_id"
  add_index "expenses", ["career"], :name => "index_expenses_on_career"
  add_index "expenses", ["exp_type"], :name => "index_expenses_on_exp_type"
  add_index "expenses", ["user_id"], :name => "index_expenses_on_user_id"

  create_table "messages", :force => true do |t|
    t.text     "msg"
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.boolean  "auto"
    t.boolean  "unread"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["from_user_id"], :name => "index_messages_on_from_user_id"
  add_index "messages", ["to_user_id"], :name => "index_messages_on_to_user_id"
  add_index "messages", ["unread"], :name => "index_messages_on_unread"

  create_table "user_stats", :force => true do |t|
    t.date     "no"
    t.integer  "total"
    t.integer  "finished"
    t.integer  "delay_material"
    t.integer  "delay_draft"
    t.integer  "delay_final"
    t.integer  "user_id"
    t.integer  "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_stats", ["no", "user_id"], :name => "index_user_stats_on_no_and_user_id", :unique => true
  add_index "user_stats", ["no", "user_type"], :name => "index_user_stats_on_no_and_user_type"
  add_index "user_stats", ["user_id"], :name => "index_user_stats_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.integer  "authority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "login_at"
    t.datetime "logout_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
