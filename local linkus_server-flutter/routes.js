const express = require("express");
const router = express.Router();
const multer = require("multer");

const storage = multer.diskStorage({
    destination: (_req, _file, cb) => {
        cb(null, "./uploads");

    },
    filename: (_req, _file, cb) => {
        cb(null, Date.now() + ".jpg");

    }
})

const upload = multer({
    storage: storage,
});

router.route("/addimage").post(upload.single("img"), (req, res) => {
    try {
        res.json({ path: req.file.filename });
    }
    catch (e) {
        return res.json({ error: e })
    }

});

module.exports = router;