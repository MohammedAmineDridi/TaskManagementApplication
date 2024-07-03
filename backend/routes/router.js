const express = require("express");

const db = require('../config/db'); // opt

const router = require("express").Router();

const controller = require("../controller/controller");

const multer  = require('multer');
const path = require('path');

router.get("/",(req,res,next)=>{
    res.send("hello world !");
});

/************** get image ************************ */

router.get('/taskManagerApplication/images/users/:imageName', (req, res) => {
  const imageName = req.params.imageName;
  const options = {
    root: 'C:/wamp64/www/taskManagerApplication/images/users' // path.join(__dirname, 'C:/wamp...../....'
  };
  res.sendFile(imageName, options, (err) => {
    if (err) {
      console.log(err);
      res.status(404).send('Image not found');
    }
  });
});

/* ************************** UPLOAD IMAGE ************************** */

// Multer configuration
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'C:/wamp64/www/taskManagerApplication/images/users') // Destination folder
    },
    filename: function (req, file, cb) {
      cb(null,file.originalname) // Rename file : file.originalname+path.extname(file.originalname)
    }
  });
  
  const upload = multer({ storage: storage });
  
  // Route for uploading image
  router.post('/upload', upload.single('avatar'), (req, res) => {
    res.send('Image uploaded successfully');
  });
/* ************************** test USER CRUD ************************** */

router.get("/users",controller.getAllUsers);

router.get("/usersExcept/:id",[], (req,res)=>{
  const id = req.params.id;
  controller.getAllUsersExcept(id,res);
});

router.get("/users/:id",[], (req,res)=>{
    const id = req.params.id;
    controller.getUserById(id,res);
});

router.get("/deleteUser/:id",[], (req,res)=>{
    const id = req.params.id;
    controller.deleteUserById(id,res);
});

/* ************************** WELCOME PAGE (Login) ************************** */

router.get("/login/:email/:password",[], (req,res)=>{
  const email = req.params.email;
  const password = req.params.password;
  controller.getUserByEmailPassword(email,password,res);
});

router.get("/newUserId",controller.getNewUserId);

/* ************************** CREATE ACCOUNT PAGE (sign up) ************************** */

router.post("/addUser",upload.single('Photo'),controller.addUser); // create account & upload photo to server

/* ************************** FORGET PASSWORD PAGE (reset password) ************************** */

router.get("/resetUserPassword/:email",[], (req,res)=>{
  const email = req.params.email;
  controller.getUserPassword(email,res);
});

router.get("/sendmail/:to/:subject/:message",[], (req,res)=>{
  const to = req.params.to;
  const subject = req.params.subject;
  const message = req.params.message;
  controller.sendEmail(to,subject,message,res);
});

/* ************************** MAIN PAGE (List of tasks and boards) ************************** */

/* *********** get percentage of done tasks = fct (uer_id) */

router.get("/getPercentageTasksDone/:userId",[], (req,res)=>{
  const userId = req.params.userId;
  controller.getPercentageTasksDone(userId,res);
});

/* *********** get list of users = fct (board_id) ==> to get (users images) */

router.get("/getListUsers_Boards/:boardId",[], (req,res)=>{
  const boardId = req.params.boardId;
  controller.getListUsers_Boards(boardId,res);
});

router.get("/get_NOT_ListUsers_Boards/:boardId",[], (req,res)=>{
  const boardId = req.params.boardId;
  controller.get_NOT_ListUsers_Boards(boardId,res);
});

/* *********** get list of users = fct (task_id) ==> to get (users images) for list of tasks */

router.get("/getListUsers_Tasks/:taskId",[], (req,res)=>{
  const taskId = req.params.taskId;
  controller.getListUsers_Tasks(taskId,res);
});

/* *********** get list of boards = fct (user_id) */

router.get("/getListBoards/:userId",[], (req,res)=>{
  const userId = req.params.userId;
  controller.getListBoards(userId,res);
});

/* *********** get list of tasks = fct (user_id)  : */

router.get("/getListTasks/:userId",[], (req,res)=>{
  const userId = req.params.userId;
  controller.getListTasks(userId,res);
});

router.get("/getListTasksByBoardId/:userId/:boardId",[], (req,res)=>{
  const userId = req.params.userId;
  const boardId = req.params.boardId;
  controller.getListTasksByBoardId(userId,boardId,res);
});

// board detail (tasks filtering)
router.get("/getListTasksByBoardId_Filter/:user_id/:boardId/:taskName?/:taskStatus?/:taskDateMin?/:taskDateMax?",[], (req,res)=>{
  const user_id = req.params.user_id;
  const boardId = req.params.boardId;

  var baseQuery = "SELECT t.*,b.* FROM tasks t JOIN boards b ON JSON_CONTAINS( b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL) AND b.id = "+boardId.toString();

  if (req.params.taskName && typeof req.params.taskName === 'string' && req.params.taskName.trim()){
    baseQuery += " AND t.taskName LIKE '%"+req.params.taskName.toString()+"%' ";
  }
  if (req.params.taskStatus && typeof req.params.taskStatus === 'string' && req.params.taskStatus.trim()){
    baseQuery += " AND t.taskStatus = "+req.params.taskStatus.toString();
  }
  if ( (req.params.taskDateMin && typeof req.params.taskDateMin === 'string' && req.params.taskDateMin.trim()) && (req.params.taskDateMax && typeof req.params.taskDateMax === 'string' && req.params.taskDateMax.trim()) ) {
    baseQuery += " AND t.taskCreationDate BETWEEN '"+req.params.taskDateMin+"' AND '"+req.params.taskDateMax+" 23:59:00' ";
  }

  console.log("==> query = "+baseQuery);
  //controller.getListTasksByBoardId_Filter(baseQuery,user_id,boardId,req.params.taskName,req.params.taskStatus,req.params.taskDateMin,req.params.taskDateMax,res);
  return new Promise((resolve,reject) =>{
    db.query(baseQuery, [] , (error,result)=>{
            if (!error){
                resolve(result);
                console.log(result);
                res.json(result);
            }
    });
});
});

/* *********** get list of tasks (filtred by : userid & taskCreationDate & taskStatus) */

router.get("/getListTasksFilter/:userId/:taskCreationDate/:taskStatus",[], (req,res)=>{
  const userId = req.params.userId;
  const taskCreationDate = req.params.taskCreationDate;
  const taskStatus = req.params.taskStatus;
  console.log("status = "+taskStatus.toString());
  controller.getListTasksFilter(userId,taskCreationDate,taskStatus,res);
});


/* *********** get list of tasks (filtred by : taskCreationDate) */

router.get("/getListDateFilterTasks/:userId/:startDate/:endDate",[], (req,res)=>{
  const userId = req.params.userId;
  const startDate = req.params.startDate;
  const endDate = req.params.endDate;
  controller.getListDateFilterTasks(userId,startDate,endDate,res);
});


/* *********** get list of tasks (filtred by : status & taskCreationDate) */

router.get("/getListDateStatusFilterTasks/:userId/:status/:startDate/:endDate",[], (req,res)=>{
  const userId = req.params.userId;
  const status = req.params.status;
  const startDate = req.params.startDate;
  const endDate = req.params.endDate;
  controller.getListDateStatusFilterTasks(userId,status,startDate,endDate,res);
});


/* *********** get nbr of active tasks = fct (user_id) */


router.get("/getNbrActiveTasks/:userId",[], (req,res)=>{
  const userId = req.params.userId;
  controller.getNbrActiveTasks(userId,res);
});

/* *********** get nbr of active tasks = fct (board_id) */


router.get("/getNbrActiveTasks_Board/:userId/:boardId",[], (req,res)=>{
  const userId = req.params.userId;
  const boardId = req.params.boardId;
  controller.getNbrActiveTasks_boards(userId,boardId,res);
});

/* *********** delete boards (only if your the creator of the board) */

router.get("/deleteBoard/:boardId",[], (req,res)=>{
  const boardId = req.params.boardId;
  controller.deleteBoard(boardId,res);
});


/* *********** delete task (for all users assigned to this task) */

router.get("/deleteTask/:taskId",[], (req,res)=>{
  const taskId = req.params.taskId;
  controller.deleteTask(taskId,res);
});
 
  
/* ************************** ADD TASK PAGE (List of tasks and boards) ************************** */

router.post("/addTask",[],controller.addTask);


/* ************************** ADD BOARD PAGE (List of tasks and boards) ************************** */

router.get("/usersFilterByUserName/:userId/:userName",[], (req,res)=>{
  const userId = req.params.userId;
  const userName = req.params.userName;
  controller.getUserFilterByUserName(userId,userName,res);
});

router.post("/addBoard",[],controller.addBoard);

router.get("/updateBoard_addTaskToBoard/:boardId/:taskId",[], (req,res)=>{
  const boardId = req.params.boardId;
  const taskId = req.params.taskId;
  controller.updateBoard_addTaskToBoard(boardId,taskId,res);
});

router.get("/updateBoard_addUserToBoard/:boardId/:userId",[], (req,res)=>{
  const boardId = req.params.boardId;
  const userId = req.params.userId;
  controller.updateBoard_addUserToBoard(boardId,userId,res);
});

router.get("/getLastTaskId",[], (req,res)=>{
  controller.getLastTaskId(res);
});

/* ************************** TASK DETAIL PAGE ************************** */

router.get("/getBoardCreatorUser/:boardId",[], (req,res)=>{
  const boardId = req.params.boardId;
  controller.getBoardCreatorUser(boardId,res);
});


router.get("/reverseTaskStatus/:taskId",[], (req,res)=>{
  const taskId = req.params.taskId;
  controller.reverseTaskStatus(taskId,res);
});

module.exports = router;
