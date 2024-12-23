
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";

module {
    public type Customer = {
        id: Nat;
        name: Text;
        email: Text;
    };

    public type CustomerID = Nat32;

    public func create(customer: Customer): async CustomerID {
        var id: CustomerID = 0;
        var customers: Trie.Trie<CustomerID, Customer> = Trie.empty();
        let customer_id = id;
        id += 1;
        customers := Trie.replace(
            customers,
            key(customer_id),
            Nat32.equal,
            ?customer
        ).0;

        return customer_id;
    };

    private func key(x: CustomerID): Trie.Key<CustomerID> {
        return {hash = x; key = x};
    };
};
