import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

module {
  public type UserId = Nat32;
  
  public type Users = {
    firstname : Text;
    lastname : Text;
  };

  public func create(user: Users) : async UserId{
    var id : UserId = 0;
    var users :Trie.Trie<UserId,Users> = Trie.empty();
    let user_id = id;
    id += 1;
    users := Trie.replace(
      users,
      key(user_id),
      Nat32.equal,
      ?user
    ).0;

    return user_id;
  };

  public func update(user_id: UserId, userinput:Users) : async Bool{
    var users :Trie.Trie<UserId,Users> = Trie.empty();
    let resultUser = Trie.find(users, key(user_id), Nat32.equal);
    let data = Option.isSome(resultUser);
    if(data){
      users := Trie.replace(
        users,
        key(user_id),
        Nat32.equal,
        ?userinput
      ).0;
    };
    return data;
  };

  public func delete(user_id: UserId) : async Bool{
    var users :Trie.Trie<UserId,Users> = Trie.empty();
    let resultUser = Trie.find(users, key(user_id), Nat32.equal);
    let data = Option.isSome(resultUser);
    if(data){
      users := Trie.replace(
        users,
        key(user_id),
        Nat32.equal,
        null
      ).0;
    };
    return data;
  };

  public query func read(user_id: UserId) : async ?Users {
    var users :Trie.Trie<UserId,Users> = Trie.empty();
    let result = Trie.find(users, key(user_id), Nat32.equal);
    return result;
  };

  public query func readAll() : async[(UserId,Users)] {
    var users :Trie.Trie<UserId,Users> = Trie.empty();
    let resultAllData = Iter.toArray(Trie.iter(users));
    return resultAllData;
  };

  private func key(x : UserId) : Trie.Key<UserId> {
    return {hash =x; key=x};
  };

};
