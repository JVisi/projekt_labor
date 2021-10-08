const express = require('express')
const app = express()

const config=require('./DB/config')
const Shop=require('./DB/Models/Shop');
const Product=require('./DB/Models/Product');

config.testConnection()
config.sequelize.sync({})

Shop.create({"name":"Spar"})
//Product.findOne({attributes:[id:1], include:[Shop]})
const _port = process.env.port || 3000

app.listen(_port,()=>{
    console.log(`Listening on ${_port}`)
})