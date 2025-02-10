module integer_package::integer_test {

  struct Global {
    count: u64
  }

  public fun add(global: &mut Global, input: u64) {
    global.count = global.count+input;
  }

  public fun sub(global: &mut Global, input: u64) {
    global.count = global.count-input;
  }

  public fun mul(global: &mut Global, input: u64) {
    global.count = global.count*input;
  }

}