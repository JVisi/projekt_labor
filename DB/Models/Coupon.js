
const sequelize = require("sequelize");
const config = require("../config");
const Shop = require("./Shop");


const Coupon = config.sequelize.define('coupon', {
    id: {
        type: sequelize.DataTypes.INTEGER,
        primaryKey: true,
        unique: true,
    },
    name: {
        type: sequelize.DataTypes.STRING,
        allowNull: false,
        unique: false
    },
    description: {
        type: sequelize.DataTypes.STRING,
        allowNull: false,
        unique: false
    },
    shopId:{
        type:sequelize.DataTypes.INTEGER,
        allowNull:false,
        unique:false
    }
}, {
    timestamps: false
});

module.exports=Coupon
