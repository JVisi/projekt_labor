
const sequelize = require("sequelize");
const config = require("../config");

const Product = config.sequelize.define('product', {
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
    price: {
        type: sequelize.DataTypes.INTEGER,
        allowNull: false,
        unique: false
    },
    barcode: {
        type: sequelize.DataTypes.STRING,
        allowNull: true,
        unique: true
    },
    shopId:{
        type:sequelize.DataTypes.INTEGER,
        allowNull:false,
        unique:false
    }
}, {
    timestamps: false
});


module.exports=Product
