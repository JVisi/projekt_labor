const sequelize = require("sequelize");
const { Op } = require("sequelize")
const Coupon = require("./Models/Coupon")
const Product = require("./Models/Product")
const Shop = require("./Models/Shop")

class QueryProvider {
    static getProducts(){
        return new Promise((resolve,reject)=>{
            Product.findAll({limit:100, include:Shop}).then((result)=>{
                let products=result.map((product)=>{
                    return product.dataValues
                })
                resolve({"products":products})
            }).catch(err=>{
                console.log(err)
                reject({"error":"error"})
            })
        })
    }
    static getShops(){
        return new Promise((resolve,reject)=>{
            Shop.findAll({limit:100}).then((result)=>{
                let shops=result.map((shop)=>{
                    return shop.dataValues
                })
                resolve({"shops":shops})
            }).catch(err=>{
                console.log(err)
                reject({"error":"error"})
            })
        })
    }
    static getCoupons(){
        let today = new Date();
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        let yyyy = today.getFullYear();

        today = yyyy + '-' + mm + '-' + dd;
        return new Promise((resolve,reject)=>{
            Coupon.findAll({limit:100,include:Shop, where:{"endDate":{[Op.gte]:today},}}).then((result)=>{
                let coupon=result.map((c)=>{
                    return c.dataValues
                })
                resolve({"coupons":coupon})
            }).catch(err=>{
                console.log(err)
                reject({"error":"error"})
            })
        })
    }
    static customProducts(shopId){
        console.log("RUNNNNININING")
        return new Promise((resolve,reject)=>{
            console.log(shopId)
            Product.findAll({limit:100, where:[{"shopId":shopId}]}).then((result)=>{
                let products=result.map((shop)=>{
                    return shop.dataValues
                })
                resolve({"customProducts":products})
            }).catch(err=>{
                console.log(err)
                reject({"error":"error"})
            })
        })
    }
    static customCoupons(shopId){
        return new Promise((resolve,reject)=>{
            console.log(shopId)
            Coupon.findAll({limit:100, where:[{"shopId":shopId, "endDate":{[Op.gte]:today}}]}).then((result)=>{
                let coupons=result.map((shop)=>{
                    return shop.dataValues
                })
                resolve({"customCoupons":coupons})
            }).catch(err=>{
                console.log(err)
                reject({"error":"error"})
            })
        })
    }
    static addShop(shopName, shopAddress){
        console.log(shopName,shopAddress)
        return new Promise((resolve,reject)=>{
            Shop.findOne({where:{
                [Op.and]:[
                    {"name":shopName,"address":shopAddress}
                ]}
            }).then(result=>{
                if(result==null){
                    Shop.create({"name":shopName,"address":shopAddress}).then(shop=>{
                        resolve({shop:shop.dataValues})
                    })
                }
                else{
                    reject({"error":"Shop on this address already exists"})
                }
            })
        })
    }
    static addCoupon(name, description, endDate, bargain, shopId){
        return new Promise((resolve,reject)=>{
            Shop.findOne({where:{"id":shopId}
            }).then(result=>{
                if(result!=null){
                    Coupon.create({
                        "name":name || result.dataValues.name+" coupon",
                        "description":description,
                        "endDate":endDate || reject({"error":"Wrong endDate for coupon"}),
                        "bargain":bargain || reject({"error":"Wrong bargain for coupon"}),
                        "shopId":shopId}).then(coupon=>{
                        resolve({"coupon":coupon.dataValues})
                    })
                }
                else{
                    reject({"error":"Shop on this address already exists"})
                }
            })
        })
    }
    static updateProduct(productId,price,name,barcode) {
        return new Promise(async (resolve,reject)=>{
            const product = await Product.findOne({where:{"id":productId}, include:Shop})
            if(product!==null){
                product.price=price===undefined ? product.price : price
                product.name=name===undefined ? product.name : name
                product.barcode=barcode===undefined ? null:barcode
                product.save()
                resolve({"product":product})
            }
            else{
                reject({"error":"No such product"})
            }
        })
    }
    static addProduct(_name,_price,_barcode, shopId){
        return new Promise((resolve,reject)=>{  
            Product.create({
                "name":_name,
                "price":_price,
                "barcode":_barcode===undefined ? null : _barcode,
                "shopId":shopId
            },{include:[{association:Shop}]}).then((result)=>{
                console.log(result)
                resolve(result)
            }).catch(err=>{
                console.log(err)
                reject({"error":"error"})
            })
        })
    }
}

module.exports.QueryProvider=QueryProvider