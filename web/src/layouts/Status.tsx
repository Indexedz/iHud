import { Fragment, useState } from "react";
import { Transition } from "@headlessui/react";
import { ProgressBar } from './components/progress'
import { IconProp } from '@fortawesome/fontawesome-svg-core';
import useEvent from "../lib/hooks/useEvent";

export interface ProgressType {
    percentage: number,
    icon: IconProp,
    name: string,
    visible: boolean,
    color?: {
        bar?: string,
        icon?: string
    }
}

export interface ProgressUpdate {
    name: string,
    percentage?: number,
    icon?: IconProp,
    visible?: boolean,
}

export default function Index() {
    const [visible, setVisible] = useState<boolean>(false);
    const [forceVisible, setForceVisible] = useState<string[]>([]);
    const [status, setStatus] = useState<ProgressType[]>([]);

    useEvent('CreateStatus', (data: ProgressType[]) => {
        setStatus((prevStatus) => {
            return [...prevStatus, ...data];
        });
    });

    useEvent("UpdateStatus", (data: ProgressUpdate[]) => {
        setStatus((prevStatus) => {
            const updatedStatus = prevStatus.map((status) => {
                const update = data.find((data) => data.name === status.name);
                if (update) {
                    return {
                        ...status,
                        percentage: update.percentage ?? status.percentage,
                        icon: update.icon ?? status.icon,
                        visible: update.visible == undefined ? status.visible : update.visible,
                    };
                }
                return status;
            });

            return updatedStatus;
        });
    })

    useEvent("SetForceVisibility", (names: string[]) => {
        setForceVisible(names)
    })

    useEvent("SetVisibleStatus", (visible: boolean) => {
        setVisible(visible)
    })

    return (
        <Transition
            appear
            show={visible}
            as={Fragment}
            enter='ease-out duration-300'
            enterFrom='opacity-0 translate-y-[100px]'
            enterTo='opacity-100 translate-y-0'
            leave='ease-in duration-200'
            leaveFrom='opacity-100 translate-y-0'
            leaveTo='opacity-0 translate-y-[100px]'
        >
            <div className='fixed bottom-2 inset-x-0 flex justify-left'>
                <div className='flex space-x-1 ms-5'>
                    {status.map((status, index) => (
                        <ProgressBar
                            key={index}
                            {...status}
                            visible={
                                forceVisible.find(e => e == status.name) ? true : status.visible
                            } />
                    ))}
                </div>
            </div>
        </Transition>
    )
};
