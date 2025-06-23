import { Notify } from "quasar";

const notifySuccessMessage = (message: string): void => {
  Notify.create({
    message: message,
    avatar: `/iconsax/verify.svg`,
    classes: "alert success",
  });
};

const notifyErrorMessage = (message: string): void => {
  Notify.create({
    message: message,
    avatar: `/iconsax/danger.svg`,
    classes: "alert danger",
  });
};

export { notifySuccessMessage, notifyErrorMessage };
