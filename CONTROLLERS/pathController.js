const Shop = require('../DB/Models/Shop');
const Product=require('../DB/Models/Product');
const Coupon=require('../DB/Models/Coupon');

module.exports = (app) => {
  app.
    get('/mobile/shops', (req,res) => {
        res.status(200)
          .end(
            JSON.stringify
              (
                Shop.findAll()
              )
          );
    });
  app.
    get('/mobile/coupons', (req,res) => {
        res.status(200)
          .end(
            JSON.stringify
              (
                Coupon.findAll()
              )
          );
    })
  app.
    get('/mobile/products', (req,res) => {
        res.status(200)
          .end(
            JSON.stringify
              (
                Product.findAll()
              )
          );
    })
  app.
    get('/mobile/customProducts', (req,res) => {
        res.status(200)
          .end(
            JSON.stringify
              (
                { 'name': 'custom products' }
              )
          );
    })

  app.
    get('/mobile/searchProduct', (req,res) => {
        res.status(200)
          .end(
            JSON.stringify
              (
                { 'name': 'search product' }
              )
          );
    })
}