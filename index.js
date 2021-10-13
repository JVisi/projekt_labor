const express = require('express')
const app = express()
require('sequelize')

const pathController = require('./CONTROLLERS/pathController')

const config=require('./DB/config')
const Shop=require('./DB/Models/Shop');
const Product=require('./DB/Models/Product');
const Coupon=require('./DB/Models/Coupon');

//config.testConnection()
config.sequelize.sync({})

//Product.create({"id": 1, "name":"Kenyér","price":350,"shopId":1})
Product.findOne({where:[{"id":1}], include:[Shop]}).then((result)=>{
    if (result != null) console.log(result.dataValues)
})
const _port = process.env.port || 3000

pathController(app);

app.listen(_port,()=>{
    console.log(`Listening on ${_port}`)
})