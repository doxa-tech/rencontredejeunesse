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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_22_203101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "adeia_action_permissions", id: :serial, force: :cascade do |t|
    t.integer "adeia_action_id"
    t.integer "adeia_permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adeia_action_id"], name: "index_adeia_action_permissions_on_adeia_action_id"
    t.index ["adeia_permission_id"], name: "index_adeia_action_permissions_on_adeia_permission_id"
  end

  create_table "adeia_actions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adeia_elements", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adeia_group_users", id: :serial, force: :cascade do |t|
    t.integer "adeia_group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adeia_group_id"], name: "index_adeia_group_users_on_adeia_group_id"
    t.index ["user_id"], name: "index_adeia_group_users_on_user_id"
  end

  create_table "adeia_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adeia_permissions", id: :serial, force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "adeia_element_id"
    t.integer "permission_type"
    t.boolean "read_right", default: false
    t.boolean "create_right", default: false
    t.boolean "update_right", default: false
    t.boolean "destroy_right", default: false
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adeia_element_id"], name: "index_adeia_permissions_on_adeia_element_id"
    t.index ["owner_type", "owner_id"], name: "index_adeia_permissions_on_owner_type_and_owner_id"
  end

  create_table "adeia_tokens", id: :serial, force: :cascade do |t|
    t.string "token"
    t.boolean "is_valid"
    t.integer "adeia_permission_id"
    t.date "exp_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adeia_permission_id"], name: "index_adeia_tokens_on_adeia_permission_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "completed_fields", force: :cascade do |t|
    t.bigint "completed_form_id"
    t.bigint "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["completed_form_id"], name: "index_completed_fields_on_completed_form_id"
    t.index ["field_id"], name: "index_completed_fields_on_field_id"
  end

  create_table "completed_forms", force: :cascade do |t|
    t.bigint "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_completed_forms_on_form_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "token"
    t.integer "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.string "code"
    t.integer "reduction"
    t.integer "category"
    t.integer "number"
    t.boolean "used", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
  end

  create_table "discounts_items", id: false, force: :cascade do |t|
    t.bigint "discount_id"
    t.bigint "item_id"
    t.index ["discount_id"], name: "index_discounts_items_on_discount_id"
    t.index ["item_id"], name: "index_discounts_items_on_item_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name"
    t.integer "field_type"
    t.boolean "required", default: false
    t.bigint "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "options"
    t.string "label"
    t.index ["form_id"], name: "index_fields_on_form_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key"
    t.string "description"
    t.boolean "active", default: true
    t.date "valid_from"
    t.date "valid_until"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.integer "number"
    t.boolean "active", default: true
    t.date "valid_until"
    t.date "valid_from"
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_bundle_id"
    t.index ["order_bundle_id"], name: "index_items_on_order_bundle_id"
  end

  create_table "markers", id: :serial, force: :cascade do |t|
    t.decimal "lat"
    t.decimal "lng"
    t.string "title"
    t.string "content"
  end

  create_table "option_orders", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.bigint "order_bundle_id"
    t.bigint "completed_form_id"
    t.index ["completed_form_id"], name: "index_option_orders_on_completed_form_id"
    t.index ["order_bundle_id"], name: "index_option_orders_on_order_bundle_id"
    t.index ["order_id"], name: "index_option_orders_on_order_id"
    t.index ["user_id"], name: "index_option_orders_on_user_id"
  end

  create_table "order_bundles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "open", default: true
    t.hstore "options"
    t.integer "limit"
    t.bigint "form_id"
    t.integer "bundle_type"
    t.integer "order_type"
    t.index ["form_id"], name: "index_order_bundles_on_form_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "item_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "amount", default: 0
    t.bigint "order_id"
    t.integer "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.boolean "pending", default: false
    t.bigint "discount_id"
    t.integer "discount_amount", default: 0
    t.boolean "limited", default: false
    t.string "type"
    t.index ["discount_id"], name: "index_orders_on_discount_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount"
    t.integer "method"
    t.datetime "time"
    t.integer "status"
    t.bigint "payid"
    t.bigint "order_id"
    t.integer "payment_type"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "refund_amount"
    t.integer "refund_status"
    t.integer "state"
    t.integer "refund_state"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.integer "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_posts_on_image_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.integer "refund_type"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_refunds_on_order_id"
    t.index ["user_id"], name: "index_refunds_on_user_id"
  end

  create_table "registrants", force: :cascade do |t|
    t.integer "gender"
    t.string "firstname"
    t.string "lastname"
    t.date "birthday"
    t.bigint "item_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ticket_id"
    t.boolean "delivered", default: false
    t.index ["item_id"], name: "index_registrants_on_item_id"
    t.index ["order_id"], name: "index_registrants_on_order_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "team_id"
    t.string "bundle_id"
    t.boolean "feedback_enabled", default: true
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token"
    t.datetime "failed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token"
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.string "thread_id"
    t.boolean "dry_run", default: false, null: false
    t.boolean "sound_is_json", default: false
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "testimonies", id: :serial, force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_testimonies_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.integer "npa"
    t.string "city"
    t.string "country"
    t.boolean "newsletter", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.string "password_digest"
    t.date "birthday"
    t.integer "gender"
    t.integer "image_id"
    t.boolean "confirmed", default: false
    t.string "verify_token"
    t.string "reset_token"
    t.datetime "reset_sent_at"
    t.index ["image_id"], name: "index_users_on_image_id"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "adeia_action_permissions", "adeia_actions"
  add_foreign_key "adeia_action_permissions", "adeia_permissions"
  add_foreign_key "adeia_group_users", "adeia_groups"
  add_foreign_key "adeia_group_users", "users"
  add_foreign_key "adeia_permissions", "adeia_elements"
  add_foreign_key "adeia_tokens", "adeia_permissions"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "completed_fields", "completed_forms"
  add_foreign_key "completed_fields", "fields"
  add_foreign_key "completed_forms", "forms"
  add_foreign_key "fields", "forms"
  add_foreign_key "items", "order_bundles"
  add_foreign_key "option_orders", "completed_forms"
  add_foreign_key "option_orders", "order_bundles"
  add_foreign_key "option_orders", "orders"
  add_foreign_key "option_orders", "users"
  add_foreign_key "order_bundles", "forms"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "discounts"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "posts", "images"
  add_foreign_key "posts", "users"
  add_foreign_key "refunds", "orders"
  add_foreign_key "refunds", "users"
  add_foreign_key "registrants", "items"
  add_foreign_key "registrants", "orders"
  add_foreign_key "testimonies", "users"
  add_foreign_key "users", "images"
end
