import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

module {
  public type OrderId = Nat32;

  public type OrderDetails = {
    userId: Nat32;
    products: [(Nat32, Nat32)]; // (ProductId, Quantity)
    totalPrice: Nat32;
    status: Text; // Example: "Pending", "Completed", "Cancelled"
  };

  public func create(order: OrderDetails): async OrderId {
    var id: OrderId = 0;
    var orders: Trie.Trie<OrderId, OrderDetails> = Trie.empty();
    let order_id = id;
    id += 1;
    orders := Trie.replace(
      orders,
      key(order_id),
      Nat32.equal,
      ?order
    ).0;

    return order_id;
  };

  public func update(order_id: OrderId, orderInput: OrderDetails): async Bool {
    var orders: Trie.Trie<OrderId, OrderDetails> = Trie.empty();
    let existingOrder = Trie.find(orders, key(order_id), Nat32.equal);
    let exists = Option.isSome(existingOrder);
    if (exists) {
      orders := Trie.replace(
        orders,
        key(order_id),
        Nat32.equal,
        ?orderInput
      ).0;
    };
    return exists;
  };

  public func delete(order_id: OrderId): async Bool {
    var orders: Trie.Trie<OrderId, OrderDetails> = Trie.empty();
    let existingOrder = Trie.find(orders, key(order_id), Nat32.equal);
    let exists = Option.isSome(existingOrder);
    if (exists) {
      orders := Trie.replace(
        orders,
        key(order_id),
        Nat32.equal,
        null
      ).0;
    };
    return exists;
  };

  public query func read(order_id: OrderId): async ?OrderDetails {
    var orders: Trie.Trie<OrderId, OrderDetails> = Trie.empty();
    let result = Trie.find(orders, key(order_id), Nat32.equal);
    return result;
  };

  public query func readAll(): async [(OrderId, OrderDetails)] {
    var orders: Trie.Trie<OrderId, OrderDetails> = Trie.empty();
    let allOrders = Iter.toArray(Trie.iter(orders));
    return allOrders;
  };

  private func key(x: OrderId): Trie.Key<OrderId> {
    return {hash = x; key = x};
  };
};
