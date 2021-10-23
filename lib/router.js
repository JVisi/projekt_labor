const {QueryProvider} = require('../DB/queries')
const {authCheck}=require('./authCheck')
const router=require('express').Router()
/* 
/mobile/shops             //Az összes boltot visszadobja
    - /mobile/coupons           //Az összes kupon
    - /mobile/products          //Az összes létező product
    - /mobile/customProducts    //Az összes termék amely megadott boltokban létezik
    - /mobile/searchProduct     //az összes termék name/price attribútumában keres adott keyword alapján

 */
function terminateFunction(req,res,f){
    f.then((result)=>{
        res.status(200).json(result)
    }).catch((msg)=>{
        res.status(300).json(msg)
    })
}

router.get('/mobile/shops',[authCheck],(req,res)=>{
    terminateFunction(req,res, QueryProvider.getShops())
});

router.get('/mobile/products',[authCheck],(req,res)=>{
    terminateFunction(req,res, QueryProvider.getProducts())
});

router.post('/mobile/customProducts',[authCheck],(req,res)=>{
    terminateFunction(req,res, QueryProvider.customProducts(req.body.shopId))
});

router.get('/mobile/Coupons',[authCheck],(req,res)=>{
    terminateFunction(req,res, QueryProvider.getCoupons())
});

router.post('/mobile/customCoupons',[authCheck],(req,res)=>{
    terminateFunction(req,res, QueryProvider.customCoupons(req.body.shopId))
});

router.post('/mobile/addShop',[authCheck],(req,res)=>{
    terminateFunction(req,res,QueryProvider.addShop(req.body.name,req.body.address))
})

router.post('/mobile/addCoupon',[authCheck],(req,res)=>{
    terminateFunction(req,res,QueryProvider.addCoupon(req.body.name,req.body.description, req.body.endDate, req.body.bargain, req.body.shopId))
})
router.post('/mobile/updateProduct',[authCheck],(req,res)=>{
    terminateFunction(req,res,QueryProvider.updateProduct(req.body.id,req.body.price,req.body.barcode))
})

router.post('/mobile/addProduct',[authCheck],(req,res)=>{
    terminateFunction(req,res,QueryProvider.addProduct(req.body.name,req.body.name,req.body.price,req.body.barcode,req.body.shopId))
})
module.exports =router