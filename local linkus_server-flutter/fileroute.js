const express = require("express");
const router = express.Router();
const multer = require("multer");
var path = require('path')
const storage = multer.diskStorage({
    destination: (_req, _file, cb) => {
        cb(null, "./uploadedDocs");

    },
    filename: (_req, _file, cb) => {
        cb(null, Date.now() +  path.extname(_file.originalname));

    }
})

const upload = multer({
    storage: storage,
});


router.route("/addimage").post(upload.any(), (req, res) => {
    try {
        res.json({ path: req.file.filename });
    }
    catch (e) {
        return res.json({ error: e })
    }

});
module.exports = router;