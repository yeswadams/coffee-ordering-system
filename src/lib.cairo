#[derive(Drop)]
enum CoffeeType {
    Americano,
    Espresso,
    Latte,
    Cappucino
} 

#[derive(Drop)] 
enum CoffeeSize {
    Small, 
    Medium,
    Large
}

#[derive(Drop)] 
struct  Stock {
    milk: u32,
    coffee_beans: u32
}

// Traits are like interfaces in other programmings languages ie React
//  Traits define a set of method that a type can implement. It alllows different types share common behavior but implementing same method
// Define a function without logic in the trait and then implement the method later in your code

trait PriceTrait{
    fn calculate_price(self: @CoffeeType, size: @CoffeeSize) -> u32;
}

// impl is used to implement a function in Cairo
// match is used to
impl CoffeePriceImpl of PriceTrait{
    fn calculate_price(self: @CoffeeType, size: @CoffeeSize) -> u32{

        let base_price: u32 = match self{
            CoffeeType::Americano => 30,
            CoffeeType::Cappucino => 49,
            CoffeeType::Espresso => 60,
            CoffeeType::Latte => 85
        };

        let size_price = match size {
            CoffeeSize::Small => 5,
            CoffeeSize::Medium => 7,
            CoffeeSize::Large => 9
        };

        base_price + size_price 
    }

}

trait StockCheckTrait { // every thing in the trait has to be implement in the impl
    fn in_stock(self: @CoffeeType, stock: @Stock ) -> bool;
    fn needed_ingredients(self: @CoffeeType);
}

impl StockCheckImpl of StockCheckTrait{
    fn in_stock(self: @CoffeeType, stock: @Stock ) -> bool{
        let beans = *stock.coffee_beans;
        let milk = *stock.milk; // used asteric to get the real value of stock since we had just reference to it without gettin its real value when we did stock: @Stock
    
    match self{
        //Needs at least 25g of coffee beans
        CoffeeType::Americano => beans >=25,
        //Needs art least 20g of coffee beans and 80ml of Milk
        CoffeeType::Cappucino => beans >= 20 && milk >=80,
        // Needs at least 20g of coffee beans
        CoffeeType::Espresso => beans >= 20,
        // Needs at least 20g of coffee beans and 100ml of milk
        CoffeeType::Latte => beans >= 20 && milk >=100,
    }

    }

    fn needed_ingredients(self: @CoffeeType){
        match self {
            CoffeeType::Americano => println!("For Americano we need : 25g of Coffee beans"),
            CoffeeType::Cappucino => println!("For Cappucino we need : 20g of Coffee beans and 80 ml of milk"),
            CoffeeType::Espresso => println!("For Espresso we need : 20g of Coffee beans"),
            CoffeeType::Latte => println!("For Latte we need : 20g of Coffee beans and 100ml of milk"),
        }
    }

}
#[derive(Drop)]
struct Order{
    coffee_type: CoffeeType,
    size: CoffeeSize
}

fn process_order(order: Order, stock: @Stock) {
    let coffee = @order.coffee_type;

    if StockCheckTrait::in_stock(coffee, stock){
        let price = PriceTrait::calculate_price(coffee, @order.size);
        println!("Your Coffee is available Total Price is: {price} ");
    }else{
        println!("we are sorry, we dont have enough Ingredient for this coffee right now");
        StockCheckTrait::needed_ingredients(coffee);
    }
}
fn main(){
    let shop_stock = Stock {milk: 200, coffee_beans: 400 }; // define the amount of stock that we have
    
    let  customer1_order = Order{coffee_type: CoffeeType::Espresso, size: CoffeeSize::Small};
    println!("Processing Your Order");
    process_order(customer1_order, @shop_stock);
}


















