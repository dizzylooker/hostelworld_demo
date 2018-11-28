connection: "the_look_events"

# include all the views
include: "*.view"

datagroup: hostelworld_demo_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: hostelworld_demo_default_datagroup

explore: distribution_centers {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: affinity {
  label: "Affinity Analysis"

  always_filter: {
    filters: {
      field: affinity.product_b_id
      value: "-NULL"
    }
  }

  join: product_a {
    from: products
    view_label: "Product A Details"
    relationship: many_to_one
    sql_on: ${affinity.product_a_id} = ${product_a.id} ;;
  }

  join: product_b {
    from: products
    view_label: "Product B Details"
    relationship: many_to_one
    sql_on: ${affinity.product_b_id} = ${product_b.id} ;;
  }
}
explore: users {}
