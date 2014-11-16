package com.bezman.background;

/**
 * Created by Terence on 11/9/2014.
 */
public class Sale {

    public String item;
    public int numOfItems;
    public double price;

    public Sale(String item, int numOfItems, double price){
        this.item = item;
        this.numOfItems = numOfItems;
        this.price = price;
    }

    public double getTotalPrice(){
        return numOfItems * price;
    }

}
