const express = require('express')
const app = express()
require('sequelize')
const config=require('./DB/config')
const bodyParser=require('body-parser')
const router=require('./lib/router')
const Shop=require('./DB/Models/Shop');
const Product=require('./DB/Models/Product');
const Coupon=require('./DB/Models/Coupon');

//Coupon.sync({force:true})
//config.testConnection()
//config.sequelize.sync({alter:true})

//Product.create({"name":"Kenyér","price":350,"shopId":1})
/* Product.findOne({where:[{"id":1}], include:[Shop]}).then((result)=>{
    console.log(result.dataValues)
}) */
const _port = process.env.port || 3000
app.use(bodyParser.json())
app.use(router)
app.listen(_port,()=>{
    console.log(`Listening on ${_port}`)
})