
const sequelize = require("sequelize");
const config = require("../config");
const Coupon = require("./Coupon");
const Product = require("./Product");


const Shop = config.sequelize.define('shop', {
    id: {
        type: sequelize.DataTypes.INTEGER,
        primaryKey: true,
        unique: true,
        autoIncrement:true
    },
    name: {
        type: sequelize.DataTypes.STRING,
        allowNull: false,
        unique: false
    },
    address: {
        type: sequelize.DataTypes.STRING,
        allowNull: true,
        unique: false
    },
}, {
    timestamps: false
});


Shop.hasMany(Product)
Product.belongsTo(Shop)


Shop.hasMany(Coupon)
Coupon.belongsTo(Shop)

module.exports=Shop
