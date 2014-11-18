package com.bezman.background;

import java.sql.Timestamp;

/**
 * Created by Terence on 11/16/2014.
 */
public class ItemSale {

    public String itemName;
    public double numOfItems;
    public double totalCash = 0;

    public Timestamp timestamp;

    public ItemSale(String itemName, double numOfItems){
        this.itemName = itemName;
        this.numOfItems = numOfItems;
    }

    public void setDate(Timestamp timestamp){
        this.timestamp = timestamp;
    }

    public double addItemCount(int count){
        this.numOfItems += count;
        return this.numOfItems;
    }

    public double addItemCount(){
        this.numOfItems++;
        return this.numOfItems;
    }
}
