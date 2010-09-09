module StoresHelper
  def format_store(store)
    "#{store.name}, #{store.address_1}, #{store.city}"
  end

  def store_options(stores)
    stores.map { |store| [ "#{store.name}, #{store.address_1}, #{store.city}", store.id ] }
  end
end
