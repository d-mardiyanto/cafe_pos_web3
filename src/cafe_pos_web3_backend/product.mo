import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

module {
  public type ProductId = Nat32;

  public type ProductDetails = {
    name: Text;
    description: Text;
    price: Nat32;
    stock: Nat32;
  };

  public func create(product: ProductDetails): async ProductId {
    var id: ProductId = 0;
    var products: Trie.Trie<ProductId, ProductDetails> = Trie.empty();
    let product_id = id;
    id += 1;
    products := Trie.replace(
      products,
      key(product_id),
      Nat32.equal,
      ?product
    ).0;

    return product_id;
  };

  public func update(product_id: ProductId, productInput: ProductDetails): async Bool {
    var products: Trie.Trie<ProductId, ProductDetails> = Trie.empty();
    let existingProduct = Trie.find(products, key(product_id), Nat32.equal);
    let exists = Option.isSome(existingProduct);
    if (exists) {
      products := Trie.replace(
        products,
        key(product_id),
        Nat32.equal,
        ?productInput
      ).0;
    };
    return exists;
  };

  public func delete(product_id: ProductId): async Bool {
    var products: Trie.Trie<ProductId, ProductDetails> = Trie.empty();
    let existingProduct = Trie.find(products, key(product_id), Nat32.equal);
    let exists = Option.isSome(existingProduct);
    if (exists) {
      products := Trie.replace(
        products,
        key(product_id),
        Nat32.equal,
        null
      ).0;
    };
    return exists;
  };

  public query func read(product_id: ProductId): async ?ProductDetails {
    var products: Trie.Trie<ProductId, ProductDetails> = Trie.empty();
    let result = Trie.find(products, key(product_id), Nat32.equal);
    return result;
  };

  public query func readAll(): async [(ProductId, ProductDetails)] {
    var products: Trie.Trie<ProductId, ProductDetails> = Trie.empty();
    let allProducts = Iter.toArray(Trie.iter(products));
    return allProducts;
  };

  private func key(x: ProductId): Trie.Key<ProductId> {
    return {hash = x; key = x};
  };
};
