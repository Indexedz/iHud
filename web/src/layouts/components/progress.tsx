import { CircularProgressbarWithChildren, buildStyles } from 'react-circular-progressbar';
import 'react-circular-progressbar/dist/styles.css';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { IconProp } from '@fortawesome/fontawesome-svg-core';
import { ProgressType } from '../Status';
import { Transition } from '@headlessui/react';
import { Fragment } from 'react';

export const ProgressBar: React.FC<ProgressType> = (props) => {
    return (
        <Transition
            appear={true}
            show={props.visible}
            as={Fragment}
            enter='ease-out duration-300'
            enterFrom='opacity-0 translate-y-[100px]'
            enterTo='opacity-100 translate-y-0'
            leave='ease-in duration-200'
            leaveFrom='opacity-100 translate-y-0'
            leaveTo='opacity-0 translate-y-[100px]'
        >
            <div className="w-11 mt-auto">
                <CircularProgressbarWithChildren
                    value={props.percentage}
                    strokeWidth={11}
                    background
                    styles={buildStyles({
                        backgroundColor: "#202020",
                        textColor: "#fff",
                        pathColor: props?.color?.bar || "#fff",
                        strokeLinecap: 'butt',
                        trailColor: "#25262B"
                    })}
                >
                    <FontAwesomeIcon icon={props.icon as IconProp} style={{
                        color: props?.color?.icon || "white"
                    }} fixedWidth />
                </CircularProgressbarWithChildren >
            </div>
        </Transition>
    )
};

