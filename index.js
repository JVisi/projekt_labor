const express = require('express')
const app = express()
require('sequelize')
const config=require('./DB/config')
const bodyParser=require('body-parser')
const router=require('./lib/router')
const Shop=require('./DB/Models/Shop');
const Product=require('./DB/Models/Product');
const Coupon=require('./DB/Models/Coupon');

//Coupon.sync({alter:true})
const _port = process.env.port || 3000
app.use(bodyParser.json())
app.use(router)
app.listen(_port,()=>{
    console.log(`Listening on ${_port}`)
})