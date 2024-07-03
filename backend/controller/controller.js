
const { end } = require("../config/db");
const model = require("../models/model");
const path = require('path');

class UserController {

    static async sendEmail(to,subject,message,res){
        var results = await model.sendEmail(to,subject,message);
        if (res){
            res.json("email is sent");
        }
    }
    
    static async getAllUsers(req,res){
        var results = await model.getAllUsers();
        if (res){
            res.json(results);
        }
    }
    // get users except me (for users selection to add to board)
    static async getAllUsersExcept(userid,res){
        var results = await model.getAllUsersExcept(userid);
        if (res){
            res.json(results);
        }
    }

    static async getUserById(id,res){
        var results = await model.getUserById(id);
        if (res){
            res.json(results);
        }
    }

    static async deleteUserById(id,res){
        var results = await model.deleteUser(id);
        if (res){
            res.json("user with id :"+id.toString()+" is deleted successfully");
        }
    }

    
    /* ************************** WELCOME PAGE (Login) ************************** */

    static async getUserByEmailPassword(email,password,res){
        var results = await model.getUserByEmailPassword(email,password);
        if (res){
            res.json(results);
        }
    }

    static async getNewUserId(req,res){
        var results = await model.getNewUserId();
        if (res){
            res.json(results);
        }
    }

    /* ************************** CREATE ACCOUNT PAGE (sign up) ************************** */

    static async addUser(req,res){
        var userName  = req.body.userName;
        var email  = req.body.email;
        var password  = req.body.password;
        var phoneNumber  = req.body.phoneNumber;
        var photoPath  = req.file.originalname;

        var result = await model.addUser(userName,email,password,phoneNumber,photoPath);
        if (result){
            res.json("user added successfully");
        } else {
            res.json("user added  failed");
        }
    }

    /* ************************** FORGET PASSWORD PAGE (reset password) ************************** */

    static async getUserPassword(email,res){
        var results = await model.getUserPassword(email);
        if (res){
            res.json(results);
        }
    }

    /* ************************** MAIN PAGE (List of tasks and boards) ************************** */

    static async getPercentageTasksDone(user_id,res){
        var results = await model.getPercentageTasksDone(user_id);
        if (res){
            res.json(results);
        }
    }

    /* *********** get list of users = fct (board_id) ==> to get (users images) for list of boards */

    static async getListUsers_Boards(board_id,res){
        var results = await model.getListUsers_Boards(board_id);
        if (res){
            res.json(results);
        }
    }

    static async get_NOT_ListUsers_Boards(board_id,res){
        var results = await model.get_Not_ListUsers_Boards(board_id);
        if (res){
            res.json(results);
        }
    }

    /* *********** get list of users = fct (task_id) ==> to get (users images) for list of tasks */

    static async getListUsers_Tasks(task_id,res){
        var results = await model.getListUsers_Tasks(task_id);
        if (res){
            res.json(results);
        }
    }

    /* *********** get list of boards = fct (user_id) */

    static async getListBoards(user_id,res){
        var results = await model.getListBoards(user_id);
        if (res){
            res.json(results);
        }
    }

    /* *********** get list of tasks = fct (user_id , board_id)  : */

    static async getListTasksByBoardId(user_id,boardId,res){
        var results = await model.getListTasksByBoardId(user_id,boardId);
        if (res){
            res.json(results);
        }
    }

    /* *********** get list of tasks = fct (user_id , board_id)  : */
    // board detail (task filtering)

    static async getListTasksByBoardId_Filter(baseQuery,user_id,boardId,taskName,taskStatus,taskDateMin,taskDateMax,res){
        var results = await model.getListTasksByBoardId_Filter(user_id,boardId,taskName,taskStatus,taskDateMin,taskDateMax);
        if (res){
            res.json(results);
        }
    }

    static async getListTasks(user_id,res){
        var results = await model.getListTasks(user_id);
        if (res){
            res.json(results);
        }
    }


    /* *********** get list of tasks (filtred by : dateCreation & taskStatus = 0/1 => active/done) */

    /* *********** get list of tasks = fct (user_id,taskCreationDate,taskStatus)  : */

    static async getListTasksFilter(user_id,taskCreationDate,taskStatus,res){
        var results = await model.getListTasksFilter(user_id,taskCreationDate,taskStatus);
        if (res){
            res.json(results);
        }
    }


    /* *********** get nbr of active tasks =fct (user_id)*/

    static async getNbrActiveTasks(user_id,res){
        var results = await model.getNbrActiveTasks(user_id);
        if (res){
            res.json(results);
        }
    }

    /* *********** get nbr of active tasks =fct (useri_d,board_id)*/

    static async getNbrActiveTasks_boards(user_id,board_id,res){
        var results = await model.getNbrActiveTasks_Board(user_id,board_id);
        if (res){
            res.json(results);
        }
    }

    /* *********** delete boards (only if your the creator of the board) */

    static async deleteBoard(id,res){
        var results = await model.deleteBoard(id);
        if (res){
            res.json(results);
        }
    }

    /* *********** delete task (for all users assigned to this task) */

    static async deleteTask(id,res){
        var results = await model.deleteTask(id);
        if (res){
            res.json(results);
        }
    }
    
    /* ************************** ADD TASK PAGE (List of tasks and boards) ************************** */

    
    static async addTask(req,res){
            var boardId = req.body.boardId;
            var taskName = req.body.taskName;
            var taskDescription = req.body.taskDescription;
            var taskStatus = req.body.taskStatus;
            var taskCreationDate = req.body.taskCreationDate;
            
            const result = await model.addTask(boardId, taskName, taskDescription, taskStatus, taskCreationDate);
            if (result){
                res.json("Task added successfully");
            } else {
                res.json("Task added failed");
            }             
    }

    /********************* ADD BOARD PAGE ************************************* */
    static async getUserFilterByUserName(userId,userName,res){
        var results = await model.getUserFilterByUserName(userId,userName);
        if (res){
            res.json(results);
        }
    }

    
    static async addBoard(req,res){
        var name  = req.body.name;
        var createdBy  = req.body.createdBy;
        var assignedTo  = req.body.assignedTo;

        var result = await model.addBoard(name,createdBy,assignedTo);
        if (result){
            res.json("board added successfully");
        } else {
            res.json("board added  failed");
        }
    }

    static async updateBoard_addTaskToBoard(boardId,taskId,res){
        var results = await model.updateBoard_addTaskToBoard(boardId,taskId);
        if (res){
            res.json(results);
        }
    }

    static async updateBoard_addUserToBoard(boardId,userId,res){
        var results = await model.updateBoard_addUsersToBoard(boardId,userId);
        if (res){
            res.json(results);
        }
    }

    static async getLastTaskId(res){
        var results = await model.getLastTaskId();
        if (res){
            res.json(results);
        }
    }

    /**************************************** TASK DETAIL PAGE ************************************** */

    static async getBoardCreatorUser(boardId,res){
        var results = await model.getBoardCreatorUser(boardId);
        if (res){
            res.json(results);
        }
    }

    static async reverseTaskStatus(taskId,res){
        var results = await model.reverseTaskStatus(taskId);
        if (res){
            res.json(results);
        }
    }

}



module.exports = UserController;